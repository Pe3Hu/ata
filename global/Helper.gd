extends Node


var rng = RandomNumberGenerator.new()
var ladder: LadderData = LadderData.new()


func _ready():
	rng.randomize()

func clear_children(parent_: Node) -> void:
	while parent_.get_child_count() > 0:
		var child = parent_.get_child(0)
		parent_.remove_child(child)
		child.queue_free()

func get_random_key(dict_: Dictionary):
	if dict_.is_empty():
		push_error("empty dictionary in get_random_key")
		return null
	
	var keys = dict_.keys()
	var total := 0.0
	
	for key in keys:
		total += dict_[key]
	
	if total <= 0:
		return null
	
	var r := rng.randf() * total
	var cumulative := 0.0
	
	for key in keys:
		cumulative += dict_[key]
		if r < cumulative:
			return key
	
	push_error("random selection failed")

#region permutation
func generate_permutations(arr_: Array) -> Array:
	var result: Array
	permute(arr_, 0, result)
	return result

func permute(arr_: Array, start_: int, result_: Array) -> void:
	if start_ == arr_.size() - 1:
		result_.append(arr_.duplicate())
		return
	
	for i in range(start_, arr_.size()):
		var temp = arr_[start_]
		arr_[start_] = arr_[i]
		arr_[i] = temp
		
		permute(arr_, start_ + 1, result_)
		
		temp = arr_[start_]
		arr_[start_] = arr_[i]
		arr_[i] = temp
#endregion

#region arrangement
func generate_arrangements_fixed_size(arr_: Array, size_: int) -> Array:
	var result_: Array = []
	generate_arrangements(arr_, [], size_, result_)
	return result_

func generate_arrangements(available_: Array, current_: Array, target_size_: int, result_: Array) -> void:
	if current_.size() == target_size_:
		result_.append(current_.duplicate())
		return
	
	for _i in available_.size():
		var element = available_[_i]
		var new_available = available_.duplicate()
		new_available.remove_at(_i)
		current_.append(element)
		
		generate_arrangements(new_available, current_, target_size_, result_)
		current_.pop_back()

func generate_unique_arrangements_fixed_size(arr_: Array, size_: int) -> Array:
	var result_: Array = []
	generate_unique_arrangements(arr_, [], 0, size_, result_)
	return result_

func generate_unique_arrangements(available_: Array, current_: Array, start_index_: int, target_size_: int, result_: Array) -> void:
	if current_.size() == target_size_:
		result_.append(current_.duplicate())
		return
	
	for _i in range(start_index_, available_.size()):
		var element = available_[_i]
		current_.append(element)
		generate_unique_arrangements(available_, current_, _i + 1, target_size_, result_)
		current_.pop_back()
#endregion

func get_matters(value_: int) -> Array[Bozo.Matter]:
	var matters: Array[Bozo.Matter]
	
	for factor in Digest.factor_to_matter:
		if value_ % factor == 0:
			matters.append(Digest.factor_to_matter[factor])
	
	return matters

func get_coord_based_on_value(value_: int, base_: int = 10) -> Vector2i:
	var x = value_ % base_
	@warning_ignore("integer_division")
	var y = floor(value_ / base_)
	return Vector2i(x, y)

func update_matter_colors(node_, matters_: Array[Bozo.Matter]) -> void:
	match matters_.size():
		1:
			var hue = Digest.matter_to_hue[matters_.front()]
			var color_a: Color = Color(Digest.matter_to_pallete[0])
			var color_b: Color = Color(Digest.matter_to_pallete[1])
			var color_c: Color = Color(Digest.matter_to_pallete[2])
			color_a.h += hue
			color_b.h += hue
			color_c.h += hue
			
			if matters_.front() == Bozo.Matter.NONE:
				color_a.s = 0
				color_b.s = 0
				color_c.s = 0
			
			node_.material.set_shader_parameter("colorA", color_a)
			node_.material.set_shader_parameter("colorB", color_b)
			node_.material.set_shader_parameter("colorC", color_c)
		2:
			var hue = Digest.matter_to_pure_hue[matters_.front()]
			node_.material.set_shader_parameter("hueA", hue)
			hue = Digest.matter_to_pure_hue[matters_.back()]
			node_.material.set_shader_parameter("hueB", hue)

func get_idea_radius(n_: int) -> float:
	#return Catalog.IDEA_SIZE.x / 2 * (1 + 1 / sin(PI / n_))
	return max(Catalog.IDEA_SIZE.x / 2 / sin(PI / n_) * 1.1, Catalog.AMBITION_RADIUS)

func find_intersection(a_: IdeaData, b_: IdeaData) -> Array:
	var result = []
	
	for _a in a_.intentions:
		for _b in b_.intentions:
			if _a.aspect == _b.aspect and _a.element == _b.element:
				result.append(_a)
	
	return result

func is_cell_inside_mainland(cell_: Vector2i) -> bool:
	return cell_.x >= 0 and cell_.y >= 0 and cell_.x < Catalog.MAINLAND_MAX_CELL.x and cell_.y < Catalog.MAINLAND_MAX_CELL.y 

func get_borderland_cells(cells_: Array[Vector2i], is_orthogonal: bool = true) -> Array[Vector2i]:
	var boundary: Array[Vector2i]
	var directions = Catalog.orthogonal_directions.duplicate()
	
	if not is_orthogonal:
		directions.append_array(Catalog.diagonal_directions)

	for cell in cells_:
		for direction in Catalog.orthogonal_directions:
			if not cells_.has(cell + direction):
				boundary.append(cell)
				break

	var borderlands: Array[Vector2i]
	
	for cell in boundary:
		for direction in directions:
			var borderland_cell = cell + direction
			
			if not borderlands.has(borderland_cell):
				borderlands.append(borderland_cell)
	
	return borderlands

func get_cluster_position(data_: ClusterData) -> Vector2:
	return data_.center * Catalog.MAINLAND_CELL_SIZE

func get_structure_position(data_: StructureData, with_cluster_: bool = false) -> Vector2:
	var position: Vector2
	
	if with_cluster_:
		position = get_cluster_position(data_.cluster)
		pass
	
	if data_.cluster as WastelandData:
		position += Vector2(data_.cell) * Catalog.MAINLAND_CELL_SIZE * 0.8
	
	return position

func wasteland_already_has_neighbor_structure(wasteland_: WastelandData, structure_type_: Bozo.Structure) -> bool:
	for neighbor_wasteland in wasteland_.neighbor_wastelands:
		for structure in neighbor_wasteland.structures:
			if structure.type == structure_type_: return true
	
	return false

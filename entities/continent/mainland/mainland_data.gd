class_name MainlandData
extends RefCounted


var shelters: Array[ShelterData]
var wastelands: Array[WastelandData]
var biomes: Array[BiomeData]

var selected_ruin: WastelandData

var terrain_to_clusters: Dictionary
var cell_to_cluster: Dictionary

var haze: HazeData = HazeData.new(self)
var beam: BeamData = BeamData.new(self)
var footprint: FootprintData = FootprintData.new(self)


#region init
func _init() -> void:
	init_shelters_and_wastelands()
	init_neighbors()
	init_biomes()
	init_structures()

func init_shelters_and_wastelands() -> void:
	var terrains = [Bozo.Terrain.DESERT, Bozo.Terrain.SWAMP, Bozo.Terrain.FOREST]
	
	for terrain in terrains:
		for _y in Catalog.MAINLAND_MATRIX.y:
			for _x in Catalog.MAINLAND_MATRIX.x:
				var anchor =  Digest.terrain_to_start_cell[terrain] + _x * Digest.terrain_to_col_shift[terrain] + _y * Digest.terrain_to_row_shift[terrain]
				
				if terrain == Bozo.Terrain.DESERT:
					var _shelter = ShelterData.new(self, anchor, terrain)
				else:
					var _wastelnad = WastelandData.new(self, anchor, terrain)
	
	update_cell_to_cluster()

func update_cell_to_cluster() -> void:
	cell_to_cluster.clear()

	for terrain in terrain_to_clusters:
		for cluster in terrain_to_clusters[terrain]:
			for cell in cluster.internals:
				cell_to_cluster[cell] = cluster

func init_neighbors() -> void:
	for wasteland in wastelands:
		wasteland.link_neighbors()
	
	for shelter in shelters:
		shelter.link_neighbors()
		shelter.link_shelter_neighbors()
#endregion

#region biome
func init_biomes() -> void:
	var attempt_limit = 300
	
	for attempt in attempt_limit:
		var pairs = pair_wastelands()
		if pairs.is_empty(): continue

		var pair_neighbors = build_pair_neighbors(pairs)
		var large_pairs = match_large_pairs(pair_neighbors)
		if large_pairs.is_empty(): continue

		var groups = form_biome_groups(pairs, large_pairs)
		var adjacency = build_biome_adjacency(groups)
		if not _color_biomes(groups, adjacency): continue
		biomes.clear()
		
		for group in groups:
			biomes.append(BiomeData.new(group.type, group.wastelands))
		
		return

func pair_wastelands() -> Array:
	var unpaired = wastelands.duplicate()
	unpaired.shuffle()
	var pairs: Array

	while not unpaired.is_empty():
		var a: WastelandData = unpaired.pop_back()
		var candidates: Array
		
		for neighbor in a.neighbor_wastelands:
			if unpaired.has(neighbor):
				candidates.append(neighbor)
		
		if candidates.is_empty(): return []
		candidates.shuffle()
		var b: WastelandData = candidates[0]
		unpaired.erase(b)
		pairs.append([a, b])

	return pairs

func build_pair_neighbors(pairs_: Array) -> Dictionary:
	var result: Dictionary
	
	for _i in pairs_.size():
		result[_i] = []
	
	for _i in pairs_.size():
		for _j in range(_i + 1, pairs_.size()):
			if _pairs_adjacent(pairs_[_i], pairs_[_j]):
				result[_i].append(_j)
				result[_j].append(_i)
	
	return result

func _pairs_adjacent(a_: Array, b_: Array) -> bool:
	for wasteland in a_:
		for neighbor in wasteland.neighbor_wastelands:
			if b_.has(neighbor):
				return true
	return false

func match_large_pairs(pair_neighbors_: Dictionary) -> Array:
	var indexs = range(pair_neighbors_.size())
	indexs.shuffle()
	
	var used: Dictionary
	var result: Array

	for _i in indexs:
		if used.has(_i): continue
		var neighbors: Array = pair_neighbors_[_i].duplicate()
		neighbors.shuffle()
		
		for _j in neighbors:
			if used.has(_j): continue
			used[_i] = true
			used[_j] = true
			result.append([_i, _j])
			break

	return result if result.size() == 3 else []

func form_biome_groups(pairs_: Array, large_pairs_: Array) -> Array:
	var groups: Array
	var used: Dictionary

	for large_pair in large_pairs_:
		used[large_pair[0]] = true
		used[large_pair[1]] = true
		var _wastelands: Array = []
		_wastelands.append_array(pairs_[large_pair[0]])
		_wastelands.append_array(pairs_[large_pair[1]])
		groups.append({"wastelands": _wastelands, "is_large": true})

	for _i in pairs_.size():
		if not used.has(_i):
			groups.append({"wastelands": pairs_[_i].duplicate(), "is_large": false})

	return groups

func build_biome_adjacency(groups_: Array) -> Dictionary:
	var adjacents: Dictionary
	
	for _i in groups_.size():
		adjacents[_i] = []
	
	for _i in groups_.size():
		for _j in range(_i + 1, groups_.size()):
			if _biomes_adjacent(groups_[_i].wastelands, groups_[_j].wastelands):
				adjacents[_i].append(_j)
				adjacents[_j].append(_i)
	
	return adjacents

func _biomes_adjacent(a_: Array, b_: Array) -> bool:
	for wasteland in a_:
		for neighbor_wasteland in wasteland.neighbor_wastelands:
			if b_.has(neighbor_wasteland):
				return true
	return false

func _color_biomes(groups_: Array, biome_adj_: Dictionary) -> bool:
	const permutations = [
		[0, 1, 2], [0, 2, 1], [1, 0, 2],
		[1, 2, 0], [2, 0, 1], [2, 1, 0]
	]
	var large_indexs: Array
	var small_indexs: Array
	
	for _i in groups_.size():
		if groups_[_i].is_large:
			large_indexs.append(_i)
		else:
			small_indexs.append(_i)

	if large_indexs.size() != 3 or small_indexs.size() != 3:return false

	for large in permutations:
		for small in permutations:
			var assignment = {}
			for _i in 3:
				assignment[large_indexs[_i]] = Catalog.biomes[large[_i]]
				assignment[small_indexs[_i]] = Catalog.biomes[small[_i]]

			var ok = true
			for _i in groups_.size():
				for _j in biome_adj_[_i]:
					if assignment[_i] == assignment[_j]:
						ok = false
						break
				if not ok:
					break

			if ok:
				for _i in groups_.size():
					groups_[_i]["type"] = assignment[_i]
				return true

	return false
#endregion

func init_structures() -> void:
	init_single_structures()
	init_structures_in_large_biomes()
	init_matter_structures()
	update_mixed_matters()
	init_ruin_structures()

func init_single_structures() -> void:
	var indexs = Catalog.center_wasteland_indexs.duplicate()
	indexs.shuffle()
	
	for structure_type in Catalog.single_sctructures:
		var wasteland = wastelands[indexs.pop_back()]
		wasteland.add_structure(structure_type)

func init_structures_in_large_biomes() -> void:
	var large_biomes = biomes.filter(func (a): return a.wastelands.size() == 4)
	
	for structure_type in Catalog.large_sctructures:
		for biome in large_biomes:
			biome.add_structure(structure_type)

func init_matter_structures() -> void:
	var missed_structures: Array
	
	for biome in biomes:
		var structure_type = Digest.matter_to_sctructure[biome.source.matter]
		
		if biome.is_empty():
			biome.add_structure(structure_type)
		else:
			missed_structures.append(structure_type)
	
	if missed_structures.is_empty(): return
	var empty_wastelands = wastelands.filter(func (a): return a.structures.is_empty())
	
	for structure_type in missed_structures:
		var options: Array
		
		for wasteland in empty_wastelands:
			if not Helper.wasteland_already_has_neighbor_structure(wasteland, structure_type):
				options.append(wasteland)
		
		if options.is_empty():
			return
		
		var wasteland = options.pick_random()
		wasteland.add_structure(structure_type)
		empty_wastelands.erase(wasteland)

func update_mixed_matters() -> void:
	for structure_type in Catalog.mixed_sctructures:
		var mixed_matters = []
		
		for wasteland in wastelands:
			if wasteland.type_to_structure.has(structure_type):
				var sctructure = wasteland.type_to_structure[structure_type]
				sctructure.roll_matters(mixed_matters)

func init_ruin_structures() -> void:
	var empty_wastelands = wastelands.filter(func (a): return a.structures.is_empty())
	var complexity = Catalog.complexity_ranks.size() - 1
	empty_wastelands.front().fill_ruins(complexity)
	
	empty_wastelands = wastelands.filter(func (a): return Catalog.center_wasteland_indexs.has(a.index))
	complexity = 0
	
	for wasteland in empty_wastelands:
		wasteland.fill_ruins(complexity)
	
	#for complexity in range(Catalog.complexity_ranks.size()-1, -1, -1):
		#var complexity_ranks = Catalog.complexity_ranks[complexity]
		#var empty_wastelands = wastelands.filter(func (a): return 4 - a.structures.size() == complexity_ranks.size())
		#empty_wastelands.shuffle()
		#
		#for _i in Catalog.complexity_amounts[complexity]:
			#var wasteland = empty_wastelands.pop_back()
			#wasteland.fill_ruins(complexity)
	#for wasteland in wastelands:
		#wasteland.fill_ruins()

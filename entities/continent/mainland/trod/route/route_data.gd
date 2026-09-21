class_name RouteData
extends RefCounted


signal trods_updated
signal selected_type_changed

var mainland: MainlandData
var start_structure: StructureData:
	set(value_):
		start_structure = value_
		recalc_wastelands()
var finish_structure: StructureData:
	set(value_):
		finish_structure = value_
		mainland.master.structure = finish_structure
		recalc_wastelands()

var type_to_trods: Dictionary
var type_to_wastelands: Dictionary

var selected_type: Bozo.Trod = Bozo.Trod.PRIMARY:
	set(value_):
		selected_type = value_
		selected_type_changed.emit()
		update_trods()


#region init
func _init(mainland_: MainlandData) -> void:
	mainland = mainland_

func recalc_wastelands() -> void:
	if start_structure == null or finish_structure == null: return
	reset()
	
	var paths = find_shortest_paths(start_structure.cluster, finish_structure.cluster, Catalog.ROUTE_MAX_PATHS)
	var types = [Bozo.Trod.PRIMARY, Bozo.Trod.SECONDARY, Bozo.Trod.TERTIARY]
	
	for _i in paths.size():
		type_to_wastelands[types[_i]] = paths[_i]
	
	recalc_trods()

func find_shortest_paths(start_cluster_: ClusterData, finish_cluster_: ClusterData, limit_: int) -> Array:
	var distances = {start_cluster_: 0}
	var queue: Array = [start_cluster_]
	
	while not queue.is_empty():
		var current: ClusterData = queue.pop_front()
		
		for neighbor in current.neighbor_wastelands:
			if not distances.has(neighbor):
				distances[neighbor] = distances[current] + 1
				queue.append(neighbor)
	
	if not distances.has(finish_cluster_): return []
	
	var all_paths: Array = []
	var stack: Array = [[start_cluster_]]
	
	while not stack.is_empty():
		if all_paths.size() >= Catalog.ROUTE_MAX_ENUMERATED: break
		
		var path: Array = stack.pop_back()
		var last: ClusterData = path.back()
		
		if last == finish_cluster_:
			all_paths.append(path)
			continue
		
		for neighbor in last.neighbor_wastelands:
			if distances.has(neighbor) and distances[neighbor] == distances[last] + 1:
				var new_path = path.duplicate()
				new_path.append(neighbor)
				stack.append(new_path)
	
	return pick_distinct(all_paths, limit_)

func pick_distinct(paths_: Array, limit_: int) -> Array:
	if paths_.size() <= limit_: return paths_
	
	var picked: Array = [paths_[0]]
	
	while picked.size() < limit_:
		var best_path = null
		var best_max_similarity = 2.0
		
		for path in paths_:
			if picked.has(path): continue
			
			var max_similarity = 0.0
			for chosen in picked:
				max_similarity = max(max_similarity, path_similarity(path, chosen))
			
			if max_similarity < best_max_similarity:
				best_max_similarity = max_similarity
				best_path = path
		
		if best_path == null: break
		picked.append(best_path)
	
	return picked

func path_similarity(a_: Array, b_: Array) -> float:
	var set_a = {}
	var set_b = {}
	
	for cluster in a_: set_a[cluster] = true
	for cluster in b_: set_b[cluster] = true
	
	var intersection = 0
	for key in set_a:
		if set_b.has(key): intersection += 1
	
	var union: int = set_a.size() + set_b.size() - intersection
	if union == 0: return 0.0
	return float(intersection) / float(union)

func recalc_trods() -> void:
	if start_structure == null or finish_structure == null: return
	if start_structure == finish_structure: return
	
	for trod_type in type_to_wastelands:
		if type_to_wastelands[trod_type].is_empty(): continue
		var current_structure = start_structure
		var counter = 30
		
		while current_structure != finish_structure and counter > 0:
			current_structure = choose_trod(trod_type, current_structure)
			counter -= 1
	
	for trod_type in type_to_wastelands:
		if type_to_trods.has(trod_type) and (abs(type_to_trods[Bozo.Trod.PRIMARY].size() - type_to_trods[trod_type].size()) > 3 or type_to_trods[trod_type].is_empty()):
			type_to_trods.erase(trod_type)
		else:
			for trod in type_to_trods[trod_type]:
				#if trod.type == Bozo.Trod.NONE:
				trod.type = trod_type
	
	trods_updated.emit()
	selected_type_changed.emit()

func choose_trod(trod_type_: Bozo.Trod, current_structure_: StructureData) -> StructureData:
	if current_structure_ == finish_structure: return current_structure_
	
	var options = current_structure_.trod_to_structure.keys()
	if options.is_empty(): return current_structure_
	
	var index = type_to_wastelands[trod_type_].find(current_structure_.cluster)
	if index == -1: return current_structure_
	
	var target_position: Vector2
	if current_structure_.cluster == finish_structure.cluster:
		target_position = Vector2(finish_structure.get_global_coord())
	else:
		index += 1
		if index >= type_to_wastelands[trod_type_].size(): return current_structure_
		target_position = type_to_wastelands[trod_type_][index].center
	
	options.sort_custom(func (a, b): return current_structure_.trod_to_structure[a].get_global_coord().distance_to(target_position) < current_structure_.trod_to_structure[b].get_global_coord().distance_to(target_position))
	options = options.filter(func (a): return current_structure_.trod_to_structure[a].get_global_coord().distance_to(target_position) == current_structure_.trod_to_structure[options.front()].get_global_coord().distance_to(target_position))
	
	var trod = options.front()
	type_to_trods[trod_type_].append(trod)
	trod.is_clockwise = current_structure_ == trod.structures.front()
	return current_structure_.trod_to_structure[trod]

func activate() -> void:
	if mainland.footprint.target_structure == null: return
	if start_structure == mainland.footprint.target_structure:
		reset()
		start_structure = null
		finish_structure = null
		return
	
	finish_structure = mainland.footprint.target_structure

func reset() -> void:
	if not type_to_trods.keys().is_empty():
		for trod_type in type_to_trods:
			for trod in type_to_trods[trod_type]:
				trod.type = Bozo.Trod.NONE
	
	trods_updated.emit()
	type_to_trods.clear()
	type_to_wastelands.clear()
	
	for trod_type in Catalog.trods:
		type_to_trods[trod_type] = []
		type_to_wastelands[trod_type] = []
#endregion

func get_travel_time() -> int:
	var travel_time: int = 0
	if type_to_trods.keys().is_empty(): return travel_time
	
	for trod in type_to_trods[selected_type]:
		travel_time += trod.travel_time
	
	return travel_time

func change_selected_type(shift_: int) -> void:
	if type_to_trods.keys().size() == 1: return
	var types = type_to_trods.keys()
	var n = types.size()
	var index = types.find(selected_type) 
	index = (index + n + shift_) % n
	selected_type = types[index]

func update_trods() -> void:
	for trod_type in type_to_trods:
		for trod in type_to_trods[trod_type]:
			trod.type_chaned.emit()

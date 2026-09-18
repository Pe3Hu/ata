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


func _init() -> void:
	init_shelters_and_wastelands()
	init_neighbors()
	init_biomes()

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


func init_biomes() -> void:
	var attempt_limit = 100
	
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
	var indexs: = range(pair_neighbors_.size())
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

	for lp in large_pairs_:
		used[lp[0]] = true
		used[lp[1]] = true
		var w: Array = []
		w.append_array(pairs_[lp[0]])
		w.append_array(pairs_[lp[1]])
		groups.append({"wastelands": w, "is_large": true})

	for i in pairs_.size():
		if not used.has(i):
			groups.append({"wastelands": pairs_[i].duplicate(), "is_large": false})

	return groups

func build_biome_adjacency(groups: Array) -> Dictionary:
	var adj = {}
	for i in groups.size():
		adj[i] = []
	for i in groups.size():
		for j in range(i + 1, groups.size()):
			if _biomes_adjacent(groups[i].wastelands, groups[j].wastelands):
				adj[i].append(j)
				adj[j].append(i)
	return adj

func _biomes_adjacent(w1: Array, w2: Array) -> bool:
	for a in w1:
		for n in a.neighbor_wastelands:
			if w2.has(n):
				return true
	return false


# --- 6. раскраска типами ------------------------------------------------
const BIOME_TYPES: Array[Bozo.Biome] = [
	Bozo.Biome.PLAIN, Bozo.Biome.SWAMP, Bozo.Biome.MOUNTAIN
]
const BIOME_PERMS = [
	[0, 1, 2], [0, 2, 1], [1, 0, 2],
	[1, 2, 0], [2, 0, 1], [2, 1, 0]
]

func _color_biomes(groups: Array, biome_adj: Dictionary) -> bool:
	var large_indexs: Array = []
	var small_indexs: Array = []
	for i in groups.size():
		if groups[i].is_large:
			large_indexs.append(i)
		else:
			small_indexs.append(i)

	if large_indexs.size() != 3 or small_indexs.size() != 3:
		return false

	for lp in BIOME_PERMS:
		for sp in BIOME_PERMS:
			var assignment = {}
			for k in 3:
				assignment[large_indexs[k]] = BIOME_TYPES[lp[k]]
				assignment[small_indexs[k]] = BIOME_TYPES[sp[k]]

			var ok = true
			for i in groups.size():
				for j in biome_adj[i]:
					if assignment[i] == assignment[j]:
						ok = false
						break
				if not ok:
					break

			if ok:
				for i in groups.size():
					groups[i]["type"] = assignment[i]
				return true

	return false

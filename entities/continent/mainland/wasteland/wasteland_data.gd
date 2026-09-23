class_name WastelandData
extends ClusterData

 
var biome: BiomeData

var structures: Array[StructureData]
var type_to_structure: Dictionary

var pattern_coords: Array[Vector2i]
var cells_options: Array[Vector2i]


#region init
func _init(maindland_: MainlandData, anchor_: Vector2i, terrain_: Bozo.Terrain) -> void:
	super._init(maindland_, anchor_, terrain_)
	
	if internals.size() == Digest.terrain_to_cluster_size[terrain] * Digest.terrain_to_cluster_size[terrain]:
		index = mainland.wastelands.size()
		mainland.wastelands.append(self)
		init_externals()
		
		if not mainland.terrain_to_clusters.has(terrain):
			mainland.terrain_to_clusters[terrain] = []
		
		mainland.terrain_to_clusters[terrain].append(self)
		
		cells_options.append_array(Catalog.structure_coords)
		pattern_coords.append_array(Catalog.wasteland_pattern_coords)
		pattern_coords.shuffle()

func add_structure(type_: Bozo.Structure, cell_: Vector2i = -Vector2i.ONE, rank_: int = -1) -> void:
	if cell_ == -Vector2i.ONE:
		cell_ = cells_options.pick_random()
	
	var structure = StructureData.new(self, type_, cell_)
	
	match type_:
		Bozo.Structure.RUIN:
			structure = RuinData.new(self, type_, cell_)
	
	structures.append(structure)
	cells_options.erase(cell_)
	type_to_structure[type_] = structure
	
	if type_ == Bozo.Structure.RUIN:
		var matter = Catalog.matters.pick_random()
		structure.matters.append(matter)
	
		if rank_ > 0:
			structure.rank = rank_

func fill_ruins(complexity_: int) -> void:
	var ranks = Catalog.complexity_ranks[complexity_]
	cells_options.shuffle()
	
	for rank in ranks:
		if cells_options.is_empty():
			print_debug('fill_ruins bug')
			return
		var cell = cells_options.back()
		add_structure(Bozo.Structure.RUIN, cell, rank)

func init_trods() -> void:
	for _i in structures.size():
		var a = structures[_i]
		
		for _j in range(_i + 1, structures.size(), 1):
			var b = structures[_j]
			var _trod = TrodData.new(mainland, [a, b])
#endregion

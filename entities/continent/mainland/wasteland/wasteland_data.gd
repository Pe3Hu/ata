class_name WastelandData
extends ClusterData

 
var biome: BiomeData
var structures: Array[StructureData]

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
		
		pattern_coords = Catalog.wasteland_pattern_coords.duplicate()
		pattern_coords.shuffle()
		init_structures()

func init_structures() -> void:
	cells_options.append_array(Catalog.structure_coords)
	cells_options.shuffle()
	var cell = cells_options.pop_back()
	#add_structure(cell, Bozo.Structure.RUIN)
	cell = cells_options.pop_back()
	#add_structure(cell, Bozo.Structure.FORGE)
	cell = cells_options.pop_back()
	#add_structure(cell, Bozo.Structure.RIFT)
	
#func init_structures() -> void:
	#
	#for cell in cells_options:
		#add_structure(cell)

func add_structure(cell_: Vector2i, type_: Bozo.Structure) -> void:
	var structure = StructureData.new(self, type_, cell_)
	structures.append(structure)
	
	if type_ == Bozo.Structure.RUIN:
		structure.matter = Catalog.matters.pick_random()
#endregion

class_name WastelandData
extends CluserData

 
var pattern_coords: Array[Vector2i]

var ruins: Array[RuinData]
var mines: Array[MineData]

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
		init_objects()

func init_objects() -> void:
	cells_options.append_array(Catalog.ruin_coords)
	cells_options.shuffle()
	var cell = cells_options.pop_back()
	add_ruin(cell)
	cell = cells_options.pop_back()
	add_mine(cell)
	
#func init_ruins() -> void:
	#
	#for cell in cells_options:
		#add_ruin(cell)

func add_ruin(cell_: Vector2i) -> void:
	var matter = Catalog.matters.pick_random()
	var ruin = RuinData.new(self, cell_, matter)
	ruins.append(ruin)

func add_mine(cell_: Vector2i) -> void:
	var matter = Catalog.matters.pick_random()
	var mine = MineData.new(self, cell_, matter)
	mines.append(mine)
#endregion

class_name MainlandData
extends RefCounted


var shelters: Array[ShelterData]
var wastelands: Array[WastelandData]

var terrain_to_clusters: Dictionary
var cell_to_cluster: Dictionary

var haze: HazeData = HazeData.new(self)


func _init() -> void:
	init_shelters_and_wastelands()
	init_neighbors()

func init_shelters_and_wastelands() -> void:
	var terrains = [Bozo.Terrain.DESERT, Bozo.Terrain.SWAMP, Bozo.Terrain.FOREST]
	
	for terrain in terrains:
		for y in Catalog.MAINLAND_MATRIX.y:
			for x in Catalog.MAINLAND_MATRIX.x:
				var anchor =  Digest.terrain_to_start_cell[terrain] + x * Digest.terrain_to_col_shift[terrain] + y * Digest.terrain_to_row_shift[terrain]
				
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
	for shelter in shelters:
		shelter.link_neighbors()
	
	for wasteland in wastelands:
		wasteland.link_neighbors()

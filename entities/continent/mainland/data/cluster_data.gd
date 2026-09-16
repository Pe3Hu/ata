class_name CluserData
extends RefCounted


var mainland: MainlandData
var terrain: Bozo.Terrain

var internals: Array[Vector2i]
var externals: Array[Vector2i]

var neighbor_shelters: Array[ShelterData]
var neighbor_wastlends: Array[WastelandData]


func _init(maindland_: MainlandData, anchor_: Vector2i, terrain_: Bozo.Terrain) -> void:
	mainland = maindland_
	terrain = terrain_
	
	init_internals(anchor_)

func init_internals(anchor_: Vector2i) -> void:
	for x in Digest.terrain_to_cluster_size[terrain]:
		for y in Digest.terrain_to_cluster_size[terrain]:
			var cell = anchor_ + Vector2i(x, y)
			
			if Helper.is_cell_inside_mainland(cell):
				internals.append(cell)
			else:
				return

func init_externals() -> void:
	externals = Helper.get_borderland_cells(internals, false) 

func link_neighbors() -> void:
	for cell in internals:
		for direction in Catalog.orthogonal_directions:
			var neighbor_cell: Vector2i = cell + direction
			if not mainland.cell_to_cluster.has(neighbor_cell): continue
			var neighbor_cluster = mainland.cell_to_cluster[neighbor_cell]
			if neighbor_cluster == self: continue

			if neighbor_cluster is WastelandData:
				if not neighbor_wastlends.has(neighbor_cluster):
					neighbor_wastlends.append(neighbor_cluster)
			elif neighbor_cluster is ShelterData:
				if not neighbor_shelters.has(neighbor_cluster):
					neighbor_shelters.append(neighbor_cluster)

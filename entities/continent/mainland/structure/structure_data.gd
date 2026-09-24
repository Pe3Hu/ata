class_name StructureData
extends RefCounted


var cluster: ClusterData
var coord: Vector2i
var type: Bozo.Structure
var matters: Array[Bozo.Matter]
var rank: int = 0

var trod_to_structure: Dictionary


func _init(cluster_: ClusterData, type_: Bozo.Structure, coord_: Vector2i = Vector2i.ZERO) -> void:
	cluster = cluster_
	type = type_
	coord = coord_
	
	if type == Bozo.Structure.MINE:
		matters.append(cluster.biome.source.matter)

func roll_matters(shift_: int) -> void:
	var index = Catalog.matters.find(cluster.biome.source.matter)
	index = (index + shift_ + Catalog.matters.size()) % Catalog.matters.size()
	var shift_matter = Catalog.matters[index]
	matters = [cluster.biome.source.matter, shift_matter]

func get_global_coord() -> Vector2i:
	return Vector2i.ONE + cluster.internals.front() + coord

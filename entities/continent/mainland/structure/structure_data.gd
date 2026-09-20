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

func roll_matters(mixed_options: Array) -> void:
	matters.append(cluster.biome.source.matter)
	var options = Catalog.matters.filter(func (a): return not matters.has(a))
	
	if not mixed_options.is_empty():
		options = options.filter(func (a): return mixed_options.has(a))
	
	var matter = options.pick_random()
	matters.append(matter)
	mixed_options.append(cluster.biome.source.matter)

func get_global_coord() -> Vector2i:
	return Vector2i.ONE + cluster.internals.front() + coord

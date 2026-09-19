class_name StructureData
extends RefCounted


var cluster: ClusterData
var cell: Vector2i
var type: Bozo.Structure
var matters: Array[Bozo.Matter]
var rank: int = 0


func _init(cluster_: ClusterData, type_: Bozo.Structure, cell_: Vector2i = Vector2i.ZERO) -> void:
	cluster = cluster_
	type = type_
	cell = cell_

func roll_matters(mixed_options: Array) -> void:
	matters.append(cluster.biome.source.matter)
	var options = Catalog.matters.filter(func (a): return not matters.has(a))
	
	if not mixed_options.is_empty():
		options = options.filter(func (a): return mixed_options.has(a))
	
	var matter = options.pick_random()
	matters.append(matter)
	mixed_options.append(cluster.biome.source.matter)

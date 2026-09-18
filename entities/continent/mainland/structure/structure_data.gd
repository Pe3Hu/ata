class_name StructureData
extends RefCounted


var cluster: ClusterData
var cell: Vector2i
var type: Bozo.Structure
var matter: Bozo.Matter


func _init(cluster_: ClusterData, type_: Bozo.Structure, cell_: Vector2i = Vector2i.ZERO) -> void:
	cluster = cluster_
	type = type_
	cell = cell_

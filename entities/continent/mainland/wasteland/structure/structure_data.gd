class_name StructureData
extends RefCounted


var wasteland: WastelandData
var cell: Vector2i
var matter: Bozo.Matter


func _init(wasteland_: WastelandData, cell_: Vector2i, matter_: Bozo.Matter) -> void:
	wasteland = wasteland_
	cell = cell_
	matter = matter_

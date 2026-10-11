class_name NightmareData
extends RefCounted

signal admit_defeat

var slumber: SlumberData
var is_defeated: bool = false


func _init() -> void:
	admit_defeat.connect(_on_defeat)

func _on_defeat() -> void:
	is_defeated = true

class_name ArsenalData
extends RefCounted


var arena: ArenaData

var guns: Array[GunData]


func _init(arena_: ArenaData) -> void:
	arena = arena_

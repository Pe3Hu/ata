class_name HordeData
extends Node


var arena: ArenaData

var beasts: Array[BeastData]


func _init(arena_: ArenaData) -> void:
	arena = arena_
	
	init_beasts()

func init_beasts() -> void:
	add_beast()

func add_beast() -> void:
	var beast = BeastData.new(self)
	beasts.append(beast)

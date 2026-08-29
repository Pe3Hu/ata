class_name Horde
extends Node2D


var beast_scene = preload("uid://cucdxbgwg7pkr")

var data: HordeData:
	set(value_):
		data = value_
		
		init_beasts()

@export var arena: Arena


func init_beasts() -> void:
	for beast_data in data.beasts:
		add_beast(beast_data)

func add_beast(beast_data_: BeastData) -> void:
	var beast = beast_scene.instantiate()
	add_child(beast)
	beast.data = beast_data_

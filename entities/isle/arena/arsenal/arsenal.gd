class_name Arsenal
extends Node2D


var data:
	set(value_):
		data = value_
		
		init_guns()

@export var arena: Arena


func _ready() -> void:
	%Gun.position = Vector2(2.5, Catalog.ARENA_TO_TILES.y * 0.5 + 0.5) * Catalog.TILE_SIZE


func init_guns() -> void:
	pass

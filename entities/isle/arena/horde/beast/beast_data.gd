class_name BeastData
extends RefCounted


var horde: HordeData
var collar: CollarData

var speed: float = 60.0
var target_position: Vector2
var is_moving: bool = false


func _init(horde_: HordeData) -> void:
	horde = horde_
	
	collar = CollarData.new(self)
	collar.healt_limit = 9
	collar.health_current = collar.healt_limit

func die() -> void:
	horde.beasts.erase(self)

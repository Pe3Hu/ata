class_name CollarData
extends RefCounted


signal health_changed

var beast: BeastData

var health_current: int = 0:
	set(value_):
		health_current = value_
		health_changed.emit()
var healt_limit: int = 0

var armor_current: int = 0
var armor_limit: int = 0

var dodge_current: int = 0
var dodge_limit: int = 0

var block_current: int = 0
var block_limit: int = 0


func _init(beast_: BeastData) -> void:
	beast = beast_


func take_damage(damage_: int = 5) -> void:
	health_current = max(health_current - damage_, 0)

class_name GloomData
extends RefCounted


signal value_changed

var rift: RiftData
var current_value: int:
	set(value_):
		current_value = value_
		value_changed.emit()
var next_value: int:
	set(value_):
		next_value = max(value_, 0)
var limit_value: int
var element: Bozo.Element = Bozo.Element.SAND
var is_elite: bool = true


func _init(rift_: RiftData, element_: Bozo.Element) -> void:
	rift = rift_
	element = element_
	
	roll_value()

func roll_value() -> void:
	limit_value = 2
	current_value = int(limit_value)
	next_value = int(limit_value)

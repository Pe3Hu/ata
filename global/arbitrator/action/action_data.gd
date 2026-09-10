class_name ActionData
extends RefCounted


var type: Bozo.Action

var stamp: StampData
 
var animation_left: int = 1:
	set(value_):
		animation_left = value_
		if animation_left == 0:
			Arbitrator.last_action = null


func execute() -> void:
	Arbitrator.last_action = self

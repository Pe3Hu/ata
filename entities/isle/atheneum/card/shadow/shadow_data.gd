class_name ShadowData
extends RefCounted


signal shade_changed

var stamp: StampData

var current_shade: int:
	set(value_):
		current_shade = value_
		shade_changed.emit()
var limit_shade: int:
	set(value_):
		limit_shade = value_
		current_shade = limit_shade


func _init(stamp_: StampData) -> void:
	stamp = stamp_
	
	calc_limit_shade()

func calc_limit_shade() -> void:
	var value = float(stamp.origin.intro.get_sum()) / 10 * 3
	
	for intro in stamp.intro_values:
		value += intro
	
	limit_shade = int(value)

class_name ShadeData
extends RefCounted


signal value_changed

var shadow: ShadowData
var current_value: int:
	set(value_):
		current_value = value_
		shadow.perfect_cantos.clear()
		
		if Mother.odeum.kitchen_scenario:
			Mother.odeum.kitchen_scenario.update_perfect_cantos()
		if Mother.odeum.bedroom_scenario:
			Mother.odeum.bedroom_scenario.update_perfect_cantos()
		
		value_changed.emit()
		
		if current_value == 0:# and Arbitrator and Arbitrator.current_phase and Arbitrator.current_phase.type == Bozo.Phase.DECISION:
			shadow.pressure.apply()
			shadow.is_perished.emit()

var limit_value: int:
	set(value_):
		limit_value = value_
		current_value = int(limit_value)


func _init(shadow_: ShadowData) -> void:
	shadow = shadow_
	calc_limit()

func calc_limit() -> void:
	var value = float(shadow.echo.soul.intro.get_sum()) / 10 * 3
	
	for intro in shadow.echo.intro_values:
		value += intro
	
	limit_value = int(value)

func reset() -> void:
	current_value = limit_value

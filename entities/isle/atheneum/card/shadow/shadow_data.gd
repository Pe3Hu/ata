class_name ShadowData
extends RefCounted


signal shade_changed
signal is_perished

var stamp: StampData
var pressure: PressureData

var current_shade: int:
	set(value_):
		current_shade = value_
		perfect_cantos.clear()
		
		if stamp.origin.atheneum.faction.odeum.kitchen_scenario:
			stamp.origin.atheneum.faction.odeum.kitchen_scenario.update_perfect_cantos()
		if stamp.origin.atheneum.faction.odeum.bedroom_scenario:
			stamp.origin.atheneum.faction.odeum.bedroom_scenario.update_perfect_cantos()
		
		shade_changed.emit()
		
		if current_shade == 0:# and Arbitrator and Arbitrator.current_phase and Arbitrator.current_phase.type == Bozo.Phase.DECISION:
			pressure.apply()
			is_perished.emit()

var limit_shade: int:
	set(value_):
		limit_shade = value_
		current_shade = int(limit_shade)

var perfect_cantos: Array[CantoData]
var action: ActionData


func _init(stamp_: StampData) -> void:
	stamp = stamp_
	
	pressure = PressureData.new()
	pressure.shadow = self
	roll_pressure_element()
	calc_limit_shade()

func calc_limit_shade() -> void:
	var value = float(stamp.origin.intro.get_sum()) / 10 * 3
	
	for intro in stamp.intro_values:
		value += intro
	
	limit_shade = int(value)

func reset() -> void:
	perfect_cantos.clear()
	current_shade = int(limit_shade)
	action = null
	roll_pressure_element()

func roll_pressure_element() -> void:
	pressure.element = Catalog.basic_elements.pick_random()

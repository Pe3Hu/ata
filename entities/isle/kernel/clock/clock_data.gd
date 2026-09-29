class_name ClockData
extends RefCounted


signal time_changed(total_hours: float)
signal hour_passed

var total_hours: float = 0.0: set = set_time


func set_time(value_: float) -> void:
	var old_hour := floori(total_hours)
	total_hours = value_
	var new_hour := floori(total_hours)
	
	if new_hour != old_hour:
		var step := signi(new_hour - old_hour)
		var h := old_hour
		
		while h != new_hour:
			h += step
			hour_passed.emit()
	
	time_changed.emit(total_hours)

func advance(hours_: float = 1) -> void:
	total_hours += hours_

# 0 = 12 часов, по часовой. Стрелка делает полный оборот за 12 игровых часов.
func get_hand_angle() -> float:
	return fmod(total_hours, 12.0) / 12.0 * TAU

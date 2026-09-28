class_name ClockData
extends RefCounted


signal time_changed(total_hours: float)

var total_hours: float = 0.0


func set_time(value: float) -> void:
	total_hours = value
	time_changed.emit(total_hours)

func advance(hours: float) -> void:
	set_time(total_hours + hours)

# 0 = 12 часов, по часовой. Стрелка делает полный оборот за 12 игровых часов.
func get_hand_angle() -> float:
	return fmod(total_hours, 12.0) / 12.0 * TAU

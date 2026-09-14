class_name StarData
extends RefCounted


signal current_changed

var asterism: AsterismData
var volume: int
var limit: int
var current: int = 0:
	set(value_):
		current = value_
		current_changed.emit()


func _init(volume_: int) -> void:
	volume = volume_
	limit = Digest.asterism_to_amount[volume]

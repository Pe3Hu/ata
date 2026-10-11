class_name RazorData
extends RefCounted


signal volume_changed

var volume: int:
	set(value_):
		volume = value_
		volume_changed.emit()
#var suffix: Bozo.Suffix
var matters: Array[Bozo.Matter]


func _init(volume_: int, matters_: Array) -> void:
	volume = volume_
	#suffix = suffix_ suffix_: Bozo.Suffix = Bozo.Suffix.PLUS
	matters.append_array(matters_)

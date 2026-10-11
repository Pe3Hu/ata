class_name RazorData
extends RefCounted


var volume: int
#var suffix: Bozo.Suffix
var matters: Array[Bozo.Matter]


func _init(volume_: int, matters_: Array) -> void:
	volume = volume_
	#suffix = suffix_ suffix_: Bozo.Suffix = Bozo.Suffix.PLUS
	matters.append_array(matters_)

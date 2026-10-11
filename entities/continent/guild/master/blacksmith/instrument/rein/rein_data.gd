class_name ReinData
extends RazorData


var element: Bozo.Element
var suffix: Bozo.Suffix = Bozo.Suffix.NONE


func _init(volume_: int, matters_: Array, element_: Bozo.Element = Bozo.Element.NONE, suffix_: Bozo.Suffix = Bozo.Suffix.NONE) -> void:
	super._init(volume_, matters_)
	element = element_
	suffix = suffix_

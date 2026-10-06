class_name PotentialData
extends RefCounted


signal index_changed
signal value_changed

var ambition: AmbitionData
var aspect: Bozo.Aspect
var element: Bozo.Element
var value: int = 0:
	set(value_):
		value = value_
		value_changed.emit()

var index: int:
	set(value_):
		index = value_
		index_changed.emit()


func _init(ambition_: AmbitionData, aspect_: Bozo.Aspect = Bozo.Aspect.NONE, element_: Bozo.Element = Bozo.Element.NONE) -> void:
	ambition = ambition_
	aspect = aspect_
	element = element_
	
	if aspect != Bozo.Aspect.NONE:
		index = ambition.aspects.size()
	else:
		index = ambition.elements.size()

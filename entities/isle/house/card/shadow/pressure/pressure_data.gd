class_name PressureData
extends RefCounted


signal element_changed
signal amount_changed

var shadow: ShadowData

var element: Bozo.Element:
	set(value_):
		element = value_
		element_changed.emit()
var amount: int = 1:
	set(value_):
		amount = value_
		amount_changed.emit()



func roll_element() -> void:
	element = Catalog.basic_elements.pick_random()

func apply() -> void:
	Mother.kernel.stepladder.pressure = self

class_name EddyData
extends RefCounted


signal value_changed

var maelstrom: MaelstromData
var element: Bozo.Element

var current_value: int = 0:
	set(value_):
		current_value = value_
		value_changed.emit()


func _init(maelstrom_: MaelstromData, element_: Bozo.Element) -> void:
	maelstrom = maelstrom_
	element = element_
	
	maelstrom.eddies.append(self)
	maelstrom.element_to_eddy[element_] = self

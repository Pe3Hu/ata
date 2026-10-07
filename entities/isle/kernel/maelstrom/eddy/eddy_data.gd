class_name EddyData
extends RefCounted


signal value_changed

var maelstrom: MaelstromData
var flux: FluxData
var element: Bozo.Element

var current_value: int = 0:
	set(value_):
		current_value = value_
		value_changed.emit()


func _init(maelstrom_: MaelstromData, element_: Bozo.Element) -> void:
	maelstrom = maelstrom_
	element = element_
	
	flux = FluxData.new(self)
	maelstrom.eddies.append(self)
	maelstrom.element_to_eddy[element_] = self
	current_value = 10

func afterburner() -> void:
	var method_type = Digest.element_to_method[element]
	var method = Mother.depredation.bank.type_to_method[method_type]
	current_value -= method.current_difficulty
	method.current_difficulty = 0

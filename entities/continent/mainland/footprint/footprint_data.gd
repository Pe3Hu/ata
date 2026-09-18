class_name FootprintData
extends RefCounted

signal structures_changed

var mainland: MainlandData

var is_silent: bool = false

var current_structure: StructureData:
	set(value_):
		if current_structure == value_: return
		current_structure = value_
		if not is_silent:
			structures_changed.emit()

var next_structure: StructureData:
	set(value_):
		if next_structure == value_: return
		if current_structure:
			next_structure = value_
			if not is_silent:
				structures_changed.emit()
		else:
			current_structure = value_

var target_structure: StructureData


func _init(mainland_: MainlandData) -> void:
	mainland = mainland_

## Атомарно: current = next; next = null. Эмитит сигнал один раз.
func advance() -> void:
	if next_structure == null: return
	var temp = next_structure
	is_silent = true
	next_structure = null
	current_structure = temp
	is_silent = false
	structures_changed.emit()

func activate() -> void:
	next_structure = target_structure
	target_structure = null

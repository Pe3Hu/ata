class_name TrodData
extends RefCounted


signal type_chaned

var mainland: MainlandData
var structures: Array[StructureData]

var type: Bozo.Trod = Bozo.Trod.NONE:
	set(value_):
		type = value_
		type_chaned.emit()


func _init(mainland_: MainlandData, structures_: Array) -> void:
	mainland = mainland_
	structures.append_array(structures_)
	
	mainland.trods.append(self)
	structures[0].trod_to_structure[self] = structures[1]
	structures[1].trod_to_structure[self] = structures[0]

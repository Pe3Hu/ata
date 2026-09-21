class_name TrodData
extends RefCounted


signal type_chaned
signal clockwise_chaned

var mainland: MainlandData
var structures: Array[StructureData]

var type: Bozo.Trod = Bozo.Trod.NONE:
	set(value_):
		type = value_
		type_chaned.emit()

var is_clockwise: bool = true:
	set(value_):
		is_clockwise = value_
		clockwise_chaned.emit()

var travel_time: int = 1


func _init(mainland_: MainlandData, structures_: Array) -> void:
	mainland = mainland_
	structures.append_array(structures_)
	
	mainland.trods.append(self)
	structures[0].trod_to_structure[self] = structures[1]
	structures[1].trod_to_structure[self] = structures[0]
	
	var flag = structures[1].cluster == structures[0].cluster
	travel_time = Digest.flag_to_travel_time[flag]
		

class_name MasterData
extends RefCounted


signal type_changed

var mainland: MainlandData
var structure: StructureData:
	set(value_):
		if structure != value_: 
			structure = value_
			
			if structure and structure.type != Bozo.Master.NONE:
				type = Digest.structure_to_master[structure.type]
var type: Bozo.Master:
	set(value_):
		if type == value_: return
		type = value_
		type_changed.emit()


func _init(mainland_: MainlandData) -> void:
	mainland = mainland_

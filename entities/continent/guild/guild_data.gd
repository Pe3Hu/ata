class_name GuildData
extends RefCounted


signal master_changed

var structure: StructureData:
	set(value_):
		if structure != value_: 
			structure = value_
			
			if structure and structure.type != Bozo.Master.NONE:
				set_current_master(Digest.structure_to_master[structure.type])

var architect = ArchitectData.new(self)
var barkeeper = BarkeeperData.new(self)

var current_master: MasterData


#func _init(isle_: IsleData) -> void:
	#isle = isle_

func set_current_master(type_: Bozo.Master):
	if type_ == Bozo.Master.NONE:
		current_master = null
		return
	
	var str_type = Bozo.enum_to_string(Bozo.Type.MASTER, type_)
	var master = get(str_type)
	
	if master:
		current_master = master
		current_master.type = type_
		master_changed.emit()

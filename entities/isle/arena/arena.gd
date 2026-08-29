class_name Arena
extends TileMapLayer



var data: ArenaData:
	set(value_):
		data = value_
		
		connect_datas()

@export var isle: Isle
@export var horde: Horde
@export var arsenal: Arsenal

func connect_datas() -> void:
	horde.data = data.horde
	arsenal.data = data.arsenal

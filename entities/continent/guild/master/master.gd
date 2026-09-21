class_name Master
extends PanelContainer


var data: MasterData


func _ready() -> void:
	data = Mother.mainland.master
	
	if data and data.type != Bozo.Master.NONE:
		%Title.text = Bozo.enum_to_string(Bozo.Type.MASTER, data.type).capitalize()

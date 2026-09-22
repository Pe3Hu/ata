class_name Master
extends PanelContainer


var data: MasterData


func _ready() -> void:
	if Mother.guild.current_master:
		data = Mother.guild.current_master
		
		if data and data.type != Bozo.Master.NONE:
			%Title.text = Bozo.enum_to_string(Bozo.Type.MASTER, data.type).capitalize()
		
		connect_signals()
		connect_datas()

func connect_signals() -> void:
	pass

func connect_datas() -> void:
	pass

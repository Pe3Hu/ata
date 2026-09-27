class_name Master
extends PanelContainer


var data: MasterData
var guild: Guild


func _ready() -> void:
	if Mother.guild.current_master:
		data = Mother.guild.current_master
		guild = get_parent()
		
		if data and data.type != Bozo.Master.NONE:
			%Title.text = Bozo.enum_to_string(Bozo.Type.MASTER, data.type).capitalize()
		
		connect_signals()
		connect_datas()

func connect_signals() -> void:
	if data and data.current_task and data.current_task.agent:
		%Agent.data = data.current_task.agent

func connect_datas() -> void:
	pass

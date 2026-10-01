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
	if data == null: return
	if not data.task_changed.is_connected(_on_task_changed):
		data.task_changed.connect(_on_task_changed)
	_on_task_changed()

func _on_task_changed() -> void:
	if data == null or data.current_task == null:
		%Agent.data = null
		return
	%Agent.data = data.current_task.agent
	%Agent.data._sync_quotums_from_tributes()

func connect_datas() -> void:
	pass

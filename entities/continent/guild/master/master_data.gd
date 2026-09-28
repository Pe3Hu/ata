class_name MasterData
extends RefCounted


signal task_changed

var guild: GuildData
var type: Bozo.Master

var tasks: Array[TaskData]

var current_task: TaskData:
	set(value_):
		current_task = value_
		#guild.current_agent = current_task.agent
		task_changed.emit()


func _init(guild_: GuildData, type_: Bozo.Master) -> void:
	guild = guild_
	type = type_
	
	init_static_tasks()

func init_static_tasks() -> void:
	pass

func changed_task(shift_: int) -> void:
	var index = tasks.find(current_task)
	var n = tasks.size()
	index = (index + shift_ + n) % n
	print([tasks.find(current_task), index, shift_, n])
	current_task = tasks[index]

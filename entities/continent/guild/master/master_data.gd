class_name MasterData
extends RefCounted


signal task_changed

var guild: GuildData
var type: Bozo.Master

var tasks: Array[TaskData]

var current_index: int = 0
var current_task: TaskData:
	set(value_):
		current_task = value_
		task_changed.emit()


#region init
func _init(guild_: GuildData, type_: Bozo.Master) -> void:
	guild = guild_
	type = type_

	init_static_tasks()

func init_static_tasks() -> void:
	pass

func init_dinamic_tasks() -> void:
	if guild.structure.type != Digest.master_to_structure[type]: return
	
	var has_locked := false
	for t in tasks:
		if t.agent != null:
			has_locked = true
			break

	if not has_locked:
		tasks.clear()
		init_tasks()

	if tasks.is_empty():
		current_task = null
	elif current_task == null or not tasks.has(current_task):
		current_task = tasks.front()

func init_tasks() -> void:
	pass
#endregion

func changed_task(shift_: int) -> void:
	var index = tasks.find(current_task)
	var n = tasks.size()
	index = (index + shift_ + n) % n
	current_task = tasks[index]

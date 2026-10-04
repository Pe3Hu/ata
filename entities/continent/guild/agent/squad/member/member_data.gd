class_name MemberData
extends RefCounted


signal preview_soul_changed

var squad: SquadData
var virtual_soul: SoulData
var preview_soul: SoulData:
	set(value_):
		preview_soul = value_
		preview_soul_changed.emit()


func _init(squad_: SquadData) -> void:
	squad = squad_
	squad.members.append(self)
	update_preview()

#region browse
func browse(shift_: int) -> void:
	if preview_soul == null: return
	if squad.agent.workload.current_progress > 0: return
	preview_soul = get_neighbor(preview_soul, shift_)

func get_neighbor(from_: SoulData, shift_: int) -> SoulData:
	var options: Array = Mother.guild.souls
	var n := options.size()
	if n == 0: return from_

	var start := options.find(from_)
	if start == -1: start = 0

	for _i in range(1, n):# + 1)
		var idx := ((start + shift_ * _i) % n + n) % n
		var soul: SoulData = options[idx]
		if soul.task == null or soul.task == squad.agent.task:
			return soul
	return from_

func can_browse() -> bool:
	if preview_soul == null: return false
	if squad.agent.workload.current_progress > 0: return false
	return get_neighbor(preview_soul, 1) != preview_soul

func update_preview() -> void:
	preview_soul = virtual_soul if virtual_soul != null else get_first_free()
	pass

func get_first_free() -> SoulData:
	if squad.agent.task == null or squad.agent.task.master == null: 
		return null
	var guild = squad.agent.task.master.guild
	for soul in guild.souls:
		if soul.task == null or soul.task == squad.agent.task:
			return soul
	return null

# Сначала двигаем preview, потом находим задачу этого воркера
func _shift_musician(shift_: int) -> void:
	if preview_soul == null: return
	if squad.agent.workload.current_progress > 0: return

	var next := get_neighbor(preview_soul, shift_)
	if next == preview_soul: return

	var task := find_task_for_soul(next)
	if task == null:
		preview_soul = next
		return

	var idx := squad.members.find(self)
	var master := squad.agent.task.master
	master.current_task = task

	# после смены задачи AgentData уже другой — берём member из него
	if task.agent != null and idx < task.agent.squad.members.size():
		task.agent.squad.members[idx].preview_soul = next

# Ищем единственную задачу, чей target soul == soul_
func find_task_for_soul(soul_: SoulData) -> TaskData:
	for task in squad.agent.task.master.tasks:
		var soul = task.get("soul")
		if soul != null and soul.name == soul_.name:
			return task
	return null
#endregion

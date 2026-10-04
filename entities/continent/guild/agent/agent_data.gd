class_name AgentData
extends RefCounted


signal locked_changed
signal quotums_changed

var task: TaskData
var squad: SquadData
var workload: WorkloadData
var quotums: Array[QuotumData]

var is_locked: bool:
	get:
		if task == null: return false
		for m in squad.members:
			if m.virtual_soul != null: return true
		return false


func _init(task_: TaskData) -> void:
	task = task_
	workload = WorkloadData.new(self)
	squad = SquadData.new(self)
	_sync_quotums_from_tributes()

# Снимок/пересинхронизация из task.tributes
func _sync_quotums_from_tributes() -> void:
	quotums.clear()
	if task == null: return
	for tribute in task.tributes:
		quotums.append(tribute.current_quotum)
	quotums_changed.emit()

# Единственная точка изменения выбора. Работает только пока не приступили.
func set_quotum(tribute_idx: int, new_quotum: QuotumData) -> bool:
	if workload.current_progress > 0: return false
	if tribute_idx < 0 or tribute_idx >= task.tributes.size(): return false
	if not task.tributes[tribute_idx].quotums.has(new_quotum): return false

	task.tributes[tribute_idx].current_quotum = new_quotum
	if quotums.size() <= tribute_idx:
		_sync_quotums_from_tributes()
	else:
		quotums[tribute_idx] = new_quotum
		quotums_changed.emit()
	return true

# Обёртка для кнопок «вперёд/назад» — зеркалит TributeData.changed_quotum,
# но пишет ещё и в agent.quotums.
func changed_quotum(tribute_idx: int, shift_: int) -> bool:
	if workload.current_progress > 0: return false
	if tribute_idx < 0 or tribute_idx >= task.tributes.size(): return false

	var tribute := task.tributes[tribute_idx]
	var list := tribute.quotums
	if list.is_empty(): return false

	var i := list.find(tribute.current_quotum)
	if i == -1: i = 0
	var n := list.size()
	i = ((i + shift_) % n + n) % n
	return set_quotum(tribute_idx, list[i])

# ЕДИНСТВЕННАЯ точка, которая привязывает рабочего к задаче.
func assign(new_soul: SoulData, member_index_: int = 0) -> void:
	if new_soul == null: return
	var member = squad.members[member_index_]
	if new_soul == member.virtual_soul: return

	# снять текущего с этой задачи (если он не мы)
	if task.agent != null and task.agent != self:
		task.agent.unassign()

	# снять нового с его прежней задачи
	if new_soul.task != null and new_soul.task != task:
		var old := new_soul.task.agent
		if old != null: old.unassign()

	# снять прежний soul ЭТОГО ЖЕ member с этой задачи
	if member.virtual_soul != null and member.virtual_soul != new_soul \
			and member.virtual_soul.task == task:
		member.virtual_soul.task = null

	member.virtual_soul = new_soul
	task.agent = self
	new_soul.task = task

	member.update_preview()   # превью должно догнать virtual_soul
	
	_sync_quotums_from_tributes()

	Mother.overseer.add_agent(self)      # подписывает на hour_passed
	locked_changed.emit()

# Снять привязку, НЕ трогая soul (AgentData остаётся как «draft»)
func _detach(member_index_: int = 0) -> void:
	var member = squad.members[member_index_]
	var changed := false

	if member.virtual_soul != null and member.virtual_soul.task == task:
		member.virtual_soul.task = null
		changed = true

	# task.agent снимаем только если больше нет привязанных member-ов
	var any_assigned := false
	for m in squad.members:
		if m.virtual_soul != null and m.virtual_soul.task == task:
			any_assigned = true
			break

	if not any_assigned and task.agent == self:
		task.agent = null
		changed = true

	if not any_assigned:
		Mother.overseer.remove_agent(self)

	if changed:
		locked_changed.emit()

func unassign() -> void:
	if task == null: return
	for _i in squad.members.size():
		_detach(_i)

func get_avg_dice() -> float:
	if squad.members.front().virtual_soul == null: return 0.0
	var value: float = float(squad.members.front().virtual_soul.intro.get_sum())
	return snapped(value / 6, 0.01)

func get_avg_hour() -> int:
	if squad.members.front().virtual_soul == null: return 0
	var avg_per_hour: float = get_avg_dice()
	if avg_per_hour <= 0.0: return 0
	var progress_left := workload.limit_progress - workload.current_progress
	return int(ceil(progress_left / avg_per_hour))

func roll_progress() -> void:
	squad.members.front().virtual_soul.intro.roll_result()
	workload.current_progress += squad.members.front().virtual_soul.intro.result * 8

func pay() -> void:
	for quotum in quotums:
		quotum.pay()

#func get_preview(index_: int = 0) -> SoulData:
	#if squad.members.is_empty(): return null
	#if squad.members[index_].preview_soul:
		#squad.members[index_].update_preview()
	#return squad.members[index_].preview_soul
func get_preview(index_: int = 0) -> SoulData:
	if squad.members.is_empty(): return null
	return squad.members[index_].preview_soul

func get_virtual(index_: int = 0) -> SoulData:
	if squad.members.is_empty(): return null
	return squad.members[index_].virtual_soul

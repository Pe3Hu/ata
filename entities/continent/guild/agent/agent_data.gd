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

func is_fully_assigned() -> bool:
	if squad.members.is_empty(): return false
	for m in squad.members:
		if m.virtual_soul == null: return false
		if m.virtual_soul.task != task: return false
	return true

# Calendar lock: все текущие preview уже назначены на эту задачу.
# Если листаем другого soul — false (кнопка «свободна», можно назначить новый состав).
func is_preview_committed() -> bool:
	if squad.members.is_empty(): return false
	for m in squad.members:
		if m.preview_soul == null: return false
		if m.preview_soul.task != task: return false
	return true

func can_assign_squad() -> bool:
	if workload.current_progress > 0: return false
	var seen: Dictionary = {}
	for m in squad.members:
		var soul: SoulData = m.preview_soul
		if soul == null: return false
		if seen.has(soul): return false
		# назначенный на другую задачу недоступен (в т.ч. ещё не начатую)
		if soul.task != null and soul.task != task: return false
		seen[soul] = true
	return true

# Назначить весь отряд по текущим preview_soul (все unique).
func assign_squad() -> void:
	if not can_assign_squad(): return

	for i in squad.members.size():
		_bind_member(i, squad.members[i].preview_soul)

	task.agent = self
	Mother.overseer.add_agent(self)
	_sync_quotums_from_tributes()
	locked_changed.emit()

# ЕДИНСТВЕННАЯ точка, которая привязывает одного рабочего к слоту.
func assign(new_soul: SoulData, member_index_: int = 0) -> void:
	if new_soul == null: return
	if member_index_ < 0 or member_index_ >= squad.members.size(): return
	if workload.current_progress > 0: return
	# чужой назначенный soul сюда не попадает через browse; страховка
	if new_soul.task != null and new_soul.task != task: return
	# нельзя дублировать soul внутри отряда
	for i in squad.members.size():
		if i == member_index_: continue
		var sibling: MemberData = squad.members[i]
		if sibling.virtual_soul == new_soul or sibling.preview_soul == new_soul:
			return

	_bind_member(member_index_, new_soul)
	task.agent = self
	Mother.overseer.add_agent(self)
	_sync_quotums_from_tributes()
	locked_changed.emit()

func _bind_member(member_index_: int, new_soul: SoulData) -> void:
	var member: MemberData = squad.members[member_index_]
	if new_soul == member.virtual_soul:
		member.update_preview()
		return

	# снять прежний soul этого member
	if member.virtual_soul != null and member.virtual_soul != new_soul:
		if member.virtual_soul.task == task:
			member.virtual_soul.task = null

	member.virtual_soul = new_soul
	new_soul.task = task
	member.update_preview()

# Снять привязку; AgentData остаётся draft на task.agent
func _detach(member_index_: int = 0) -> void:
	if member_index_ < 0 or member_index_ >= squad.members.size(): return
	var member: MemberData = squad.members[member_index_]
	var changed := false

	if member.virtual_soul != null:
		if member.virtual_soul.task == task:
			member.virtual_soul.task = null
		member.virtual_soul = null
		changed = true

	var any_assigned := false
	for m in squad.members:
		if m.virtual_soul != null:
			any_assigned = true
			break

	# draft остаётся: task.agent не обнуляем
	if not any_assigned:
		Mother.overseer.remove_agent(self)

	if changed:
		locked_changed.emit()

func unassign(force_: bool = false) -> void:
	if task == null: return
	# во время исполнения снимать нельзя; force — завершение задачи
	if not force_ and workload.current_progress > 0: return

	var changed := false
	for m in squad.members:
		if m.virtual_soul == null: continue
		if m.virtual_soul.task == task:
			m.virtual_soul.task = null
		m.virtual_soul = null
		changed = true

	# draft остаётся на task.agent
	Mother.overseer.remove_agent(self)
	if changed:
		locked_changed.emit()

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

func get_preview(index_: int = 0) -> SoulData:
	if squad.members.is_empty(): return null
	if index_ < 0 or index_ >= squad.members.size(): return null
	return squad.members[index_].preview_soul

func get_virtual(index_: int = 0) -> SoulData:
	if squad.members.is_empty(): return null
	if index_ < 0 or index_ >= squad.members.size(): return null
	return squad.members[index_].virtual_soul

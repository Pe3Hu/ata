class_name AgentData
extends RefCounted


signal locked_changed

var task: TaskData
var origin: OriginData
var workload: WorkloadData

var is_locked: bool:
	get: return task != null and task.agent == self


func _init(task_: TaskData) -> void:
	task = task_
	workload = WorkloadData.new(self)

# ЕДИНСТВЕННАЯ точка, которая привязывает рабочего к задаче.
func assign(new_origin: OriginData) -> void:
	if new_origin == null: return
	if new_origin == origin and task.agent == self: return

	# снять текущего с этой задачи (если он не мы)
	if task.agent != null and task.agent != self:
		task.agent.unassign()

	# снять нового с его прежней задачи
	if new_origin.task != null and new_origin.task != task:
		var old := new_origin.task.agent
		if old != null: old.unassign()

	origin = new_origin
	task.agent = self
	origin.task = task

	Mother.overseer.add_agent(self)      # подписывает на hour_passed
	locked_changed.emit()

# Снять привязку, НЕ трогая origin (AgentData остаётся как «draft»)
func _detach() -> void:
	var changed := false

	if task != null and task.agent == self:
		task.agent = null
		changed = true

	if origin != null and origin.task == task:
		origin.task = null
		changed = true

	Mother.overseer.remove_agent(self)   # сам проверит, есть ли в списке

	if changed:
		locked_changed.emit()

func unassign() -> void:
	if task == null: return
	# реально нечего чистить
	if task.agent != self and (origin == null or origin.task != task): return
	_detach()

func get_avg_dice() -> float:
	if origin == null: return 0.0
	var value: float = float(origin.intro.get_sum())
	return snapped(value / 6, 0.01)

func get_avg_hour() -> int:
	if origin == null: return 0
	var avg_per_hour: float = get_avg_dice()
	if avg_per_hour <= 0.0: return 0
	var progress_left := workload.limit_progress - workload.current_progress
	return int(ceil(progress_left / avg_per_hour))

func roll_progress() -> void:
	origin.intro.roll_result()
	workload.current_progress += origin.intro.result * 8

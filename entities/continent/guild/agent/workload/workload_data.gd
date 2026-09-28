class_name WorkloadData
extends RefCounted


signal overtime_changed

var agent: AgentData
var current_progress: int:
	set(value_):
		current_progress = min(value_, limit_progress)
		update_overtime()
var limit_progress: int = 20
var current_overtime: int
var next_overtime: int


func _init(agent_: AgentData) -> void:
	agent = agent_
	calc_progress()

func calc_progress() -> void:
	limit_progress = Digest.master_to_workloads[agent.task.master.type][agent.task.rank] * Catalog.AVG_HOUR_PROGRESS
	current_progress = 0

func update_overtime() -> void:
	if current_overtime > limit_progress: return
	var percent = float(current_progress) / limit_progress
	next_overtime = ceil(Catalog.MAX_OVERTIME * percent)
	overtime_changed.emit()

class_name AgentData
extends RefCounted


var task: TaskData
var origin: OriginData
var workload: WorkloadData


func _init(task_: TaskData) -> void:
	task = task_
	workload = WorkloadData.new(self)


func get_avg_hour() -> int:
	var avg_per_hour: float = get_avg_dice()
	var progress_left = workload.limit_progress - workload.current_progress
	var hours = ceil(progress_left / avg_per_hour)
	return hours

func get_avg_dice() -> float:
	var value: float = float(task.agent.origin.intro.get_sum())
	value = snapped(value / 6, 0.01)
	return value

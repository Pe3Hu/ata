class_name AgentData
extends RefCounted


var task: TaskData
var origin: OriginData
var workload: WorkloadData


func _init(task_: TaskData) -> void:
	task = task_
	workload = WorkloadData.new(self)

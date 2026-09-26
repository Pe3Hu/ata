class_name Agent
extends PanelContainer


var data: AgentData:
	set(value_):
		data = value_
		connect_datas()


func connect_datas() -> void:
	%Workload.data = data.workload
	%HourglassTimer.wait_time = Gear.workloads[Gear.tempo]


func _on_hourglass_timer_timeout() -> void:
	data.workload.current_progress += Helper.rng.randi_range(3, 5) 

class_name Agent
extends PanelContainer


var data: AgentData:
	set(value_):
		data = value_
		
		connect_datas()
		update_agent()


func _ready() -> void:
	var color = Digest.element_to_color[Bozo.Element.SAND]
	%Dice.update_color(color)
	%HourglassTimer.wait_time = Gear.workloads[Gear.tempo]

func connect_datas() -> void:
	%Workload.data = data.workload

func update_agent() -> void:
	data.origin = Mother.guild.agent_origin
	%AgentName.text = data.origin.name

func _on_hourglass_timer_timeout() -> void:
	if data and data.workload:
		data.workload.current_progress += Helper.rng.randi_range(2, 4) 

func _on_previous_agent_button_pressed() -> void:
	Mother.guild.change_agent_origin(-1)
	update_agent()

func _on_next_agent_button_pressed() -> void:
	Mother.guild.change_agent_origin(1)
	update_agent()

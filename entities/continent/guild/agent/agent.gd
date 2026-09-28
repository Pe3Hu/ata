class_name Agent
extends PanelContainer


var data: AgentData:
	set(value_):
		data = value_
		
		connect_datas()
		connect_signals()
		update_agent()


func _ready() -> void:
	var color = Digest.element_to_color[Bozo.Element.SAND]
	%Dice.update_color(color)
	%HourglassTimer.wait_time = Gear.hourglass[Gear.tempo]

func connect_datas() -> void:
	%Workload.data = data.workload

func connect_signals() -> void:
	data.workload.overtime_changed.connect(_on_overtime_changed)
	#_on_overtime_changed()

func _on_overtime_changed() -> void:
	%WorkoadLabel.text = '%d/%d' % [data.workload.current_progress, data.workload.limit_progress]
	var avg_hour = data.get_avg_hour()
	%HourglassLabel.text = "~%d" % avg_hour if avg_hour > 0 else "0"

func update_agent() -> void:
	data.origin = Mother.guild.agent_origin
	update_colors()
	update_labels()

func update_colors() -> void:
	%Calendar.apply_matter(data.origin.matter)
	var color = Digest.matter_to_color[data.origin.matter]
	%Top.get_theme_stylebox("panel").bg_color = color

func update_labels() -> void:
	%AgentName.text = data.origin.name
	%DiceLabel.text = str(data.get_avg_dice())
	_on_overtime_changed()

func _on_hourglass_timer_timeout() -> void:
	if data and data.workload:
		data.workload.current_progress += Helper.rng.randi_range(2, 4) 

func _on_previous_agent_button_pressed() -> void:
	Mother.guild.change_agent_origin(-1)
	update_agent()

func _on_next_agent_button_pressed() -> void:
	Mother.guild.change_agent_origin(1)
	update_agent()

class_name Agent
extends PanelContainer


var data: AgentData:
	set(value_):
		data = value_
		
		preview_origin = data.origin if data.origin != null else _first_free()
		connect_datas()
		connect_signals()
		update_view()

var preview_origin: OriginData


func _ready() -> void:
	var color = Digest.element_to_color[Bozo.Element.SAND]
	%Dice.update_color(color)

func connect_datas() -> void:
	%Workload.data = data.workload
	%Calendar.update_textures()

func connect_signals() -> void:
	data.workload.overtime_changed.connect(_on_overtime_changed)
	#_on_overtime_changed()

func _on_overtime_changed() -> void:
	%WorkoadLabel.text = '%d/%d' % [data.workload.current_progress, data.workload.limit_progress]

	if preview_origin == null:
		%HourglassLabel.text = "0"
		return

	var avg_dice = snapped(float(preview_origin.intro.get_sum()) / 6.0, 0.01)
	var avg_hour := 0
	if avg_dice > 0.0:
		var left := data.workload.limit_progress - data.workload.current_progress
		avg_hour = int(ceil(left / avg_dice))

	%HourglassLabel.text = "~%d" % avg_hour if avg_hour > 0 else "0"

func update_view() -> void:
	if data == null: return

	# некого показывать — прячем содержимое
	if preview_origin == null:
		%AgentHBox.visible = false
		%Calendar.visible = false
		%WorkoadLabel.text = "—"
		%HourglassLabel.text = "—"
		%DiceLabel.text = "—"
		%AgentName.text = ""
		return

	%AgentHBox.visible = true
	%Calendar.visible = true
	update_colors()
	update_labels()
	_on_overtime_changed()

	var can_browse = _can_browse()
	%PreviousAgentButton.visible = can_browse
	%NextAgentButton.visible = can_browse
	%Calendar.update_textures()

func update_colors() -> void:
	%Calendar.apply_matter(preview_origin.matter)
	var color = Digest.matter_to_color[preview_origin.matter]
	%Top.get_theme_stylebox("panel").bg_color = color

func update_labels() -> void:
	%AgentName.text = preview_origin.name
	%DiceLabel.text = str(snapped(float(preview_origin.intro.get_sum()) / 6.0, 0.01))
	_on_overtime_changed()

func _on_next_agent_button_pressed() -> void:
	_browse(+1)

func _on_previous_agent_button_pressed() -> void:
	_browse(-1)

func _browse(shift_: int) -> void:
	if preview_origin == null: return
	if data.workload.current_progress > 0: return
	preview_origin = _find_neighbor(preview_origin, shift_)
	update_view()

func _find_neighbor(from_: OriginData, shift_: int) -> OriginData:
	var options: Array = Mother.guild.barkeeper.origins
	var n := options.size()
	if n == 0: return from_

	var start := options.find(from_)
	if start == -1: start = 0

	for _i in range(1, n + 1):
		var idx := ((start + shift_ * _i) % n + n) % n
		var origin: OriginData = options[idx]
		if origin.task == null or origin.task == data.task:
			return origin
	return from_

func _can_browse() -> bool:
	if preview_origin == null: return false
	if data.workload.current_progress > 0: return false
	return _find_neighbor(preview_origin, 1) != preview_origin

func _first_free() -> OriginData:
	for origin in Mother.guild.barkeeper.origins:
		if origin.task == null or origin.task == data.task:
			return origin
	return null

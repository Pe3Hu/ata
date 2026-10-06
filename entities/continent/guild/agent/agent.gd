class_name Agent
extends PanelContainer


var data: AgentData:
	set(value_):
		if value_ == null: return
		data = value_
		
		connect_datas()
		connect_signals()
		update_view()

@export var calendar: Calendar


#region init
#func _ready() -> void:
	#var color = Digest.element_to_color[Bozo.Element.SAND]
	#%Dice.update_color(color)

func connect_datas() -> void:
	%Workload.data = data.workload
	%Squad.data = data.squad
	%Calendar.update_textures()
	update_visibles()

func connect_signals() -> void:
	if not data.workload.overtime_changed.is_connected(_on_overtime_changed):
		data.workload.overtime_changed.connect(_on_overtime_changed)
	#_on_overtime_changed()

func _on_overtime_changed() -> void:
	#%WorkoadLabel.text = '%d/%d' % [data.workload.current_progress, data.workload.limit_progress]

	if data.get_preview() == null:
		%HourglassLabel.text = "0"
		return

	var avg_dice = snapped(float(data.get_preview().intro.get_sum()) / 6.0, 0.01)
	var avg_hour := 0
	if avg_dice > 0.0:
		var left := data.workload.limit_progress - data.workload.current_progress
		avg_hour = int(ceil(left / avg_dice))

	%HourglassLabel.text = "~%d" % avg_hour if avg_hour > 0 else "0"

func update_view() -> void:
	if data == null: return

	# некого показывать — прячем содержимое
	if data.get_preview() == null:
		%Squad.visible = false
		%Calendar.visible = false
		#%WorkoadLabel.text = "—"
		%HourglassLabel.text = "—"
		#%DiceLabel.text = "—"
		return

	%Squad.visible = true
	update_colors()
	update_labels()
	_on_overtime_changed()

	# visible calendar зависит от локации (is_calendar) внутри update_textures
	%Calendar.update_textures()

func update_colors() -> void:
	%Calendar.update_colors()
	%Squad.update_colors()

func update_labels() -> void:
	if data == null: return
	%Squad.update_labels()
	var preview = data.get_preview()
	if preview == null:
		#%DiceLabel.text = "—"
		_on_overtime_changed()
		return
	#%DiceLabel.text = str(snapped(float(preview.intro.get_sum()) / 6.0, 0.01))
	_on_overtime_changed()

func update_visibles() -> void:
	var flag = Digest.master_to_squad_size[data.task.master.type] == 1
	%WorkloadPanel.visible = flag
	%Squad.last_member_separator(false)
#endregion

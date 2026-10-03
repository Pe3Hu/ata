class_name Agent
extends PanelContainer


var data: AgentData:
	set(value_):
		if value_ == null: return
		data = value_
		
		preview_soul = data.soul if data.soul != null else get_first_free()
		connect_datas()
		connect_signals()
		update_view()

var preview_soul: SoulData


#region init
func _ready() -> void:
	var color = Digest.element_to_color[Bozo.Element.SAND]
	%Dice.update_color(color)

func connect_datas() -> void:
	%Workload.data = data.workload
	%Calendar.update_textures()

func connect_signals() -> void:
	if not data.workload.overtime_changed.is_connected(_on_overtime_changed):
		data.workload.overtime_changed.connect(_on_overtime_changed)
	#_on_overtime_changed()

func _on_overtime_changed() -> void:
	%WorkoadLabel.text = '%d/%d' % [data.workload.current_progress, data.workload.limit_progress]

	if preview_soul == null:
		%HourglassLabel.text = "0"
		return

	var avg_dice = snapped(float(preview_soul.intro.get_sum()) / 6.0, 0.01)
	var avg_hour := 0
	if avg_dice > 0.0:
		var left := data.workload.limit_progress - data.workload.current_progress
		avg_hour = int(ceil(left / avg_dice))

	%HourglassLabel.text = "~%d" % avg_hour if avg_hour > 0 else "0"

func update_view() -> void:
	if data == null: return

	# некого показывать — прячем содержимое
	if preview_soul == null:
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

	var canbrowse = can_browse()
	%PreviousAgentButton.visible = canbrowse
	%NextAgentButton.visible = canbrowse
	%Calendar.update_textures()

func update_colors() -> void:
	%Calendar.apply_matter(preview_soul.matter)
	var color = Digest.matter_to_color[preview_soul.matter]
	%Top.get_theme_stylebox("panel").bg_color = color

func update_labels() -> void:
	%AgentName.text = preview_soul.name
	%GradeIcon.texture = load('res://entities/isle/house/card/echo/images/rank/%s.png' % Bozo.enum_to_string(Bozo.Type.RANK, preview_soul.rank))
	%TalentIcon.texture = load('res://entities/isle/house/card/echo/images/talent/%d.png' % preview_soul.talent)

	%DiceLabel.text = str(snapped(float(preview_soul.intro.get_sum()) / 6.0, 0.01))
	_on_overtime_changed()
#endregion

#region buttons
func _on_next_agent_button_pressed() -> void:
	if data.task.master.type == Bozo.Master.MUSICIAN:
		_shift_musician(1)
		return
	
	browse(1)

func _on_previous_agent_button_pressed() -> void:
	if data.task.master.type == Bozo.Master.MUSICIAN:
		_shift_musician(-1)
		return
	
	browse(-1)
#endregion

#region browse
func browse(shift_: int) -> void:
	if preview_soul == null: return
	if data.workload.current_progress > 0: return
	preview_soul = get_neighbor(preview_soul, shift_)
	update_view()

func get_neighbor(from_: SoulData, shift_: int) -> SoulData:
	var options: Array = Mother.guild.barkeeper.souls
	var n := options.size()
	if n == 0: return from_

	var start := options.find(from_)
	if start == -1: start = 0

	for _i in range(1, n + 1):
		var idx := ((start + shift_ * _i) % n + n) % n
		var soul: SoulData = options[idx]
		if soul.task == null or soul.task == data.task:
			return soul
	return from_

func can_browse() -> bool:
	if preview_soul == null: return false
	if data.workload.current_progress > 0: return false
	return get_neighbor(preview_soul, 1) != preview_soul

func get_first_free() -> SoulData:
	for soul in Mother.guild.barkeeper.souls:
		if soul.task == null or soul.task == data.task:
			return soul
	return null

# Сначала двигаем preview, потом находим задачу этого воркера
func _shift_musician(shift_: int) -> void:
	if preview_soul == null: return
	if data.workload.current_progress > 0: return

	var next := get_neighbor(preview_soul, shift_)
	if next == preview_soul: return

	var task := find_task_for_soul(next)
	if task == null:
		# на этого воркера нет задачи — просто обновляем превью
		preview_soul = next
		update_view()
		return

	# Смена current_task → task_changed → Master._on_task_changed
	# → %Agent.data = task.agent → сеттер Agent.data сбросит preview_soul.
	# Поэтому явно восстанавливаем его на next.
	data.task.master.current_task = task
	preview_soul = next
	update_view()

# Ищем единственную задачу, чей target soul == soul_
func find_task_for_soul(soul_: SoulData) -> TaskData:
	for task in data.task.master.tasks:
		var soul = task.get("soul")
		if soul != null and soul.name == soul_.name:
			return task
	return null
#endregion

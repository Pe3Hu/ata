class_name Member
extends PanelContainer


var data: MemberData:
	set(value_):
		if value_ == null: return
		data = value_
		
		connect_signals()


func connect_signals() -> void:
	if not data.preview_soul_changed.is_connected(_on_preview_soul_changed):
		data.preview_soul_changed.connect(_on_preview_soul_changed)
	
	_on_preview_soul_changed()

func _on_preview_soul_changed() -> void:
	var flag = data.can_browse()
	%PreviousSoulButton.visible = flag
	%NextSoulButton.visible = flag
	
	if data.preview_soul != null:
		update_labels()
		update_colors()

func update_labels() -> void:
	if data == null or data.preview_soul == null: return
	%MemberName.text = data.preview_soul.name
	%GradeIcon.texture = load('res://entities/isle/house/card/echo/images/rank/%s.png' % Bozo.enum_to_string(Bozo.Type.RANK, data.preview_soul.rank))
	%TalentIcon.texture = load('res://entities/isle/house/card/echo/images/talent/%d.png' % data.preview_soul.talent)


func update_colors() -> void:
	if data == null or data.preview_soul == null: return
	var color = Digest.matter_to_color[data.preview_soul.matter]
	%Top.get_theme_stylebox("panel").bg_color = color

#region buttons
func _on_next_soul_button_pressed() -> void:
	if data.squad.agent.task.master.type == Bozo.Master.MUSICIAN:
		data._shift_musician(1)
		return
	
	data.browse(1)

func _on_previous_soul_button_pressed() -> void:
	if data.squad.agent.task.master.type == Bozo.Master.MUSICIAN:
		data._shift_musician(-1)
		return
	
	data.browse(-1)
#endregion

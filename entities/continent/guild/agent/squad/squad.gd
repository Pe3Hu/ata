class_name Squad
extends PanelContainer


var member_scene = preload('uid://c54rtqlyoc2i3')

@export var agent: Agent

var data: SquadData:
	set(value_):
		data = value_
		
		connect_signals()
		init_members()

func connect_signals() -> void:
	if data == null: return
	for member_data in data.members:
		if not member_data.preview_soul_changed.is_connected(_on_preview_soul_changed):
			member_data.preview_soul_changed.connect(_on_preview_soul_changed)
	
	_on_preview_soul_changed()

func _on_preview_soul_changed() -> void:
	if agent == null: return
	if agent.calendar:
		agent.calendar.update_textures()
	agent.update_labels()

func init_members() -> void:
	Helper.clear_children(%Members)
	
	for member_data in data.members:
		add_member(member_data)

func add_member(member_data_: MemberData) -> void:
	var member = member_scene.instantiate()
	%Members.add_child(member)
	member.data = member_data_

func update_colors() -> void:
	for member in %Members.get_children():
		member.update_colors()

func update_labels() -> void:
	for member in %Members.get_children():
		member.update_labels()

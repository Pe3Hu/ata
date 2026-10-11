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
	
	if not data.members_reordered.is_connected(_on_members_reordered):
		data.members_reordered.connect(_on_members_reordered)
	
	match data.agent.task.master.type:
		Bozo.Master.DEMON:
			if not data.agent.task.turnpike_changed.is_connected(_on_turnpike_chaned):
				data.agent.task.turnpike_changed.connect(_on_turnpike_chaned)

func _on_preview_soul_changed() -> void:
	if agent == null: return
	if agent.calendar:
		agent.calendar.update_textures()
	agent.update_labels()

func _on_turnpike_chaned() -> void:
	for member_data in data.members:
		if member_data.virtual_soul == null:
			member_data.preview_soul = null
	for member_data in data.members:
		member_data.update_preview()
	
	sync_browse()

func init_members() -> void:
	Helper.clear_children(%Members)
	
	for member_data in data.members:
		add_member(member_data)
	
	var can_reorder = data.members.size() > 2
	if data.agent.task is SlumberData and not data.agent.task.can_fill_squad():
		can_reorder = false
	%Buttons.visible = can_reorder

func add_member(member_data_: MemberData) -> void:
	var member = member_scene.instantiate()
	%Members.add_child(member)
	member.squad = self
	member.data = member_data_

func update_colors() -> void:
	for member in %Members.get_children():
		member.update_colors()

func update_labels() -> void:
	for member in %Members.get_children():
		member.update_labels()

func last_member_separator(flag_: bool) -> void:
	var member = %Members.get_child(-1)
	member.update_separtor(flag_)

func sync_browse() -> void:
	for member in %Members.get_children():
		member._on_preview_soul_changed()

func _on_members_reordered() -> void:
	for _i in data.members.size():
		var member = %Members.get_child(_i)
		member.data = data.members[_i]

func _on_previous_button_pressed() -> void:
	data.reoder_members(-1)

func _on_next_button_pressed() -> void:
	data.reoder_members(1)

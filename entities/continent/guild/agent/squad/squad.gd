class_name Squad
extends PanelContainer


var member_scene = preload('uid://c54rtqlyoc2i3')

var data: SquadData:
	set(value_):
		data = value_
		init_members()


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

class_name Beam
extends ColorRect


var data: BeamData:
	set(value_):
		data = value_
		
		connect_signals()


func connect_signals() -> void:
	data.shelters_changed.connect(_on_shelters_changed)
	_on_shelters_changed()

func _on_shelters_changed() -> void:
	visible = data.next_shelter != null
	offset_transform_position = data.get_anchor() * Catalog.MAINLAND_CELL_SIZE
	material.set_shader_parameter('gravity_angle', data.get_angle())

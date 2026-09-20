class_name Trod
extends Line2D


var data: TrodData:
	set(value_):
		data = value_
		
		connect_signals()
		init_points()

func connect_signals() -> void:
	data.type_chaned.connect(_on_type_changed)
	_on_type_changed()

func _on_type_changed() -> void:
	visible = data.type != Bozo.Trod.NONE

func init_points() -> void:
	var a = Helper.get_structure_position(data.structures[0], true)
	var b = Helper.get_structure_position(data.structures[1], true)
	points = [a, b]

class_name Pie
extends Node2D


var data: PieData:
	set(value_):
		data = value_
		init_slices()

var slice_scene = preload("uid://86usnsbi56nk")

@export_category("Geometry")
var inner_radius: float = 160.0:
	set(value_):
		inner_radius = value_
		outer_radius = inner_radius / hollow_ratio
var outer_radius: float

@export_range(0.0, 1.0) var hollow_ratio: float = 0.7
@export_range(2, 32) var arc_subdivisions: int = 8

var thickness = 4


func _ready() -> void:
	position = get_parent().size / 2
	inner_radius = inner_radius


func init_slices() -> void:
	Helper.clear_children(%Slices)

	for slice_data in data.slices:
		add_slice(slice_data)

func add_slice(slice_data_: SliceData) -> void:
	var slice = slice_scene.instantiate()
	%Slices.add_child(slice)
	slice.pie = self
	slice.data = slice_data_

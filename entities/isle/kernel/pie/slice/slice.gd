class_name Slice
extends Polygon2D


var data: SliceData:
	set(value_):
		data = value_
		
		connect_signals()
		calc_angles()
		create_polygon()
		%Volume.texture = load("res://entities/dice/images/%d.png" % data.volume)

var pie: Pie

var angle_start = 0.0
var angle_end = 0.0


#region init
func connect_signals() -> void:
	data.amount_changed.connect(_on_amount_changed)
	_on_amount_changed()

func _on_amount_changed() -> void:
	%Amount.text = str(data.amount)
	%Amount.visible = data.amount > 0


func calc_angles() -> void:
	var angle_step = TAU / float(Catalog.slice_matters.size())
	var index = data.index - Catalog.SLICE_INDEX_SHIFT
	angle_start = -PI * 0.5 + angle_step * index
	angle_end = angle_start + angle_step

func create_polygon() -> void:
	var points: PackedVector2Array
	var middle_points: PackedVector2Array
	var center: Vector2 = Vector2.ZERO

	for _i in range(pie.arc_subdivisions + 1):
		var t = float(_i) / pie.arc_subdivisions
		var angle = lerp(angle_start, angle_end, t)
		var point = Vector2.from_angle(angle) * pie.inner_radius
		
		points.append(point)
		center += point

	for _i in range(pie.arc_subdivisions, -1, -1):
		var t = float(_i) / pie.arc_subdivisions
		var angle = lerp(angle_start, angle_end, t)
		var point = Vector2.from_angle(angle) * pie.outer_radius

		points.append(point)
		center += point
		
		var middle_point = Vector2.from_angle(angle) * (pie.inner_radius + pie.outer_radius) / 2
		middle_points.append(middle_point)
	
	polygon = points
	%BorderLine.points = points
	%MiddleLine.points = middle_points
	
	center /= points.size()
	center -= %Volume.size * 0.5
	var l = center.length() - pie.inner_radius * 0.1
	var norm = center.normalized()
	%Volume.position = norm * l
	l = center.length() + pie.inner_radius * 0.115
	%Amount.position = norm * l
	
	Helper.update_colors(self, data.matter)
#endregion

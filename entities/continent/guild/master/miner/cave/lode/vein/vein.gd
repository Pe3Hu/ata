class_name Vein
extends Polygon2D


var data: VeinData:
	set(value_):
		data = value_
		
		calc_angles()
		create_polygon()
		%Percent.text = str(data.percent) + '%'
		%Volume.texture = load("res://entities/dice/images/%d.png" % data.volume)

var lode: Lode

var angle_start = 0.0
var angle_end = 0.0


#region init
func calc_angles() -> void:
	angle_start = -PI * 0.5 + data.start_angle
	angle_end = angle_start + TAU * data.percent / 100

func create_polygon() -> void:
	var points: PackedVector2Array
	var middle_points: PackedVector2Array
	var center: Vector2 = Vector2.ZERO

	var inner_radius: float = Catalog.LODE_OUTER_RADIUS - Catalog.LODE_SECTOR_HEIGHT

	for _i in range(Catalog.LODE_ARC_SUBDIVISIONS + 1):
		var t = float(_i) / Catalog.LODE_ARC_SUBDIVISIONS
		var angle = lerp(angle_start, angle_end, t)
		var point = Vector2.from_angle(angle) * inner_radius
		points.append(point)
		center += point

	for _i in range(Catalog.LODE_ARC_SUBDIVISIONS, -1, -1):
		var t = float(_i) / Catalog.LODE_ARC_SUBDIVISIONS
		var angle = lerp(angle_start, angle_end, t)
		var point = Vector2.from_angle(angle) * Catalog.LODE_OUTER_RADIUS
		points.append(point)
		center += point

		var middle_point = Vector2.from_angle(angle) * (inner_radius + Catalog.LODE_OUTER_RADIUS) * 0.5
		middle_points.append(middle_point)

	polygon = points
	%BorderLine.points = points
	%MiddleLine.points = middle_points

	center /= points.size()
	var norm: Vector2 = center.normalized()
	var vol_factor = 0.75
	var pct_factor = 0.25
	
	if data.percent <= 25:
		vol_factor = 0.7
	
	if data.percent == 15:
		vol_factor = 0.66

	var vol_radius: float = Catalog.LODE_OUTER_RADIUS - Catalog.LODE_SECTOR_HEIGHT * vol_factor
	var pct_radius: float = Catalog.LODE_OUTER_RADIUS - Catalog.LODE_SECTOR_HEIGHT * pct_factor

	%Volume.position  = norm * vol_radius - %Volume.size  * 0.5
	%Percent.position = norm * pct_radius - %Percent.size * 0.5

	Helper.update_matter_colors(self, [data.lode.matter])
#endregion

class_name Circuit
extends Node2D


var size: float = 144.0

var shelter_to_point: Dictionary
var marker_shelter: ShelterData:
	set(value_):
		marker_shelter = value_
		%Body.position = shelter_to_point[marker_shelter]

func _ready() -> void:
	Helper.update_matter_colors(%Body, [Bozo.Matter.GAS])

func update_points() -> void:
	var donor_points := PackedVector2Array()
	
	for shelter in Mother.guild.scout.extrenals:
		donor_points.append(Helper.get_cluster_position(shelter))
	
	Helper.clear_children(%Lines)
	Helper.clear_children(%Borders)
	var points = fit_points_to_square(donor_points)
	
	for _i in points.size():
		var a = points[_i]
		var _j = (_i + 1) % points.size()
		var b = points[_j]
		add_line(a, b)
	
	for point in points:
		var sprite = Sprite2D.new()
		sprite.scale = Vector2.ONE * 0.25
		sprite.position = point
		%Borders.add_child(sprite)
		sprite.texture = load('uid://o11jh0lsyt5j')

func add_line(a_: Vector2, b_: Vector2) -> void:
	var line = Line2D.new()
	#line.points = [a_, b_]
	var offset = (b_ - a_) * 0.1
	line.points = [a_ + offset, b_ - offset]
	%Lines.add_child(line)
	line.width = 4
	line.material = ShaderMaterial.new()
	line.material.shader = load('uid://cqihu1xnoipnu')
	line.texture_mode = Line2D.LINE_TEXTURE_TILE

func fit_points_to_square(points_: PackedVector2Array) -> PackedVector2Array:
	if points_.is_empty(): return PackedVector2Array()
	
	var min_p: Vector2 = points_[0]
	var max_p: Vector2 = points_[0]
	
	for p in points_:
		min_p.x = min(min_p.x, p.x)
		min_p.y = min(min_p.y, p.y)
		max_p.x = max(max_p.x, p.x)
		max_p.y = max(max_p.y, p.y)

	var bbox := max_p - min_p
	var max_dim: float = maxf(bbox.x, bbox.y)
	if max_dim <= 0.0: return points_

	var scale_factor := size / max_dim
	var center := (min_p + max_p) * 0.5
	
	shelter_to_point.clear()
	var result := PackedVector2Array()
	result.resize(points_.size())
	
	for _i in points_.size():
		result[_i] = (points_[_i] - center) * scale_factor + Vector2(size, size) * 0.5
		var shelter = Mother.guild.scout.extrenals[_i]
		shelter_to_point[shelter] = result[_i]
	
	return result

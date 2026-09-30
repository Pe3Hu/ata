class_name Circuit
extends Node2D


const border_texture = preload('uid://o11jh0lsyt5j')

var size: float = 144.0

var shelter_to_point: Dictionary

@export var markers: Array[Sprite2D]


func _ready() -> void:
	for marker in markers:
		Helper.update_matter_colors(marker, [Bozo.Matter.GAS])
	
	connect_signals()

func connect_signals() -> void:
	pass

func apply_donors(donors_: PackedVector2Array) -> void:
	Helper.clear_children(%Lines)
	Helper.clear_children(%Borders)
	var points = fit_points_to_square(donors_)
	
	for _i in points.size():
		var a = points[_i]
		var _j = (_i + 1) % points.size()
		var b = points[_j]
		add_line(a, b)
	
	for point in points:
		add_border(point)

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

func add_border(point_: Vector2) -> void:
	var sprite = Sprite2D.new()
	sprite.scale = Vector2.ONE * 0.25
	sprite.position = point_
	%Borders.add_child(sprite)
	sprite.texture = border_texture

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
		var shelter: ShelterData
		
		if self as ScoutCircuit:
			shelter = Mother.guild.scout.extrenals[_i]
		
		if self as LightkeeperCircuit:
			shelter = Mother.guild.scout.internals[_i]
		
		shelter_to_point[shelter] = result[_i]
	
	return result

func update_markers(shelters_: Array) -> void:
	reset_markers()
	
	for _i in shelters_.size():
		var marker = markers[_i]
		marker.position = shelter_to_point[shelters_[_i]]
		marker.visible = true

func reset_markers() -> void:
	for marker in markers:
		marker.visible = false

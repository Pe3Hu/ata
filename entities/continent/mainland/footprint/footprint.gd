extends Node2D
class_name Footprint

enum State { CIRCLING, MOVING }

var data: FootprintData:
	set(value_):
		if data == value_:
			return
		if data and data.structures_changed.is_connected(_on_structures_changed):
			data.structures_changed.disconnect(_on_structures_changed)
		data = value_
		connect_signals()

var right_texture = preload('uid://ced1aqrcnk41l')
var radius: float = 44#48.0
var total_footprints: int = 12    # должно быть чётным
var step_interval: float = 0.6
var fade_in: float = 0.08
var fade_hold: float = 0.4
var fade_out: float = 1.0
var side_offset: float = 6.0

@export var move_speed: float = 48.0
@export var curve_samples: int = 48
@export_range(0.2, 1.0) var curve_tension: float = 0.45

var _step: int = 0
var _timer: float = 0.0
var _state: int = State.CIRCLING
var _center: Vector2 = Vector2.ZERO
var _circle_phase: float = 0.0

var _walker_pos: Vector2 = Vector2.ZERO
var _walker_dir: Vector2 = Vector2.RIGHT
var _distance_accum: float = 0.0
var _step_spacing: float = 1.0

var _path = PackedVector2Array()
var _path_index: int = 0

var _last_footprint_pos: Vector2 = Vector2.ZERO
var _has_last_footprint: bool = false


#region init
func connect_signals() -> void:
	data.structures_changed.connect(_on_structures_changed)
	_on_structures_changed()

func _on_structures_changed() -> void:
	if data == null or data.current_structure == null:
		visible = false
		_state = State.CIRCLING
		return

	visible = true

	if data.next_structure != null:
		if _state != State.MOVING:
			_begin_move()
	else:
		_center = Helper.get_structure_position(data.current_structure, true)
		position = _center
		_state = State.CIRCLING
#endregion

func _process(delta: float) -> void:
	match _state:
		State.CIRCLING:
			_timer += delta
			while _timer >= step_interval:
				_timer -= step_interval
				_spawn_circle_step()
		State.MOVING:
			_process_moving(delta)

#region circling
func _spawn_circle_step() -> void:
	var t = _circle_phase + float(_step) * TAU / float(total_footprints)
	var dir = Vector2(cos(t), sin(t))
	var is_left = (_step & 1) == 1
	# tangent = (-sin, cos); tangent.rotated(PI/2) = -dir
	# coord = center + dir*radius + (-dir)*(±side_offset)
	var r = radius - (side_offset if is_left else -side_offset)
	_emit_footprint(is_left, _center + dir * r, t + PI)
	_step = (_step + 1) % total_footprints

func _emit_footprint(is_left: bool, coord_pos: Vector2, rot: float) -> void:
	_last_footprint_pos = coord_pos
	_has_last_footprint = true

	var sprite = Sprite2D.new()
	sprite.texture = right_texture
	if not is_left:
		sprite.scale.x = -1.0
	sprite.modulate.a = 0.0
	sprite.position = coord_pos
	sprite.rotation = rot
	get_parent().add_child(sprite)
	sprite.position = coord_pos

	# Tween на спрайте — умрёт вместе со спрайтом, даже если Footprint уберут.
	var tw = sprite.create_tween()
	tw.tween_property(sprite, "modulate:a", 1.0, fade_in)
	tw.tween_interval(fade_hold)
	tw.tween_property(sprite, "modulate:a", 0.0, fade_out)
	tw.tween_callback(sprite.queue_free)
#endregion

#region moving
func _begin_move() -> void:
	var from_pos: Vector2 = Helper.get_structure_position(data.current_structure, true)
	var to_pos: Vector2 = Helper.get_structure_position(data.next_structure, true)

	var t = _circle_phase + float(_step) * TAU / float(total_footprints)
	var p0 = from_pos + Vector2(cos(t), sin(t)) * radius
	var d0 = Vector2(-sin(t), cos(t))

	if from_pos.distance_squared_to(to_pos) < 0.0001:
		_walker_pos = to_pos
		_arrive(to_pos)
		return

	var approach_dir = (to_pos - from_pos).normalized()
	var p3 = to_pos + approach_dir.rotated(-PI * 0.5) * radius
	var d1 = approach_dir

	var dist = from_pos.distance_to(to_pos)
	var tension = max(dist * curve_tension, 30.0)

	_build_path(p0, p0 + d0 * tension, p3 - d1 * tension, p3)

	_center = from_pos
	_walker_pos = p0
	_walker_dir = d0
	_step_spacing = max(1.0, (TAU * radius) / float(total_footprints))
	_distance_accum = _step_spacing
	_state = State.MOVING

func _build_path(p0: Vector2, p1: Vector2, p2: Vector2, p3: Vector2) -> void:
	_path.resize(curve_samples + 1)
	_path[0] = p0
	var inv = 1.0 / float(curve_samples)
	for i in range(1, curve_samples + 1):
		_path[i] = _bezier(p0, p1, p2, p3, float(i) * inv)
	_path_index = 1

func _bezier(p0: Vector2, p1: Vector2, p2: Vector2, p3: Vector2, u: float) -> Vector2:
	var v = 1.0 - u
	return v*v*v*p0 + 3*v*v*u*p1 + 3*v*u*u*p2 + u*u*u*p3

func _process_moving(delta: float) -> void:
	var remaining = move_speed * delta
	while remaining > 0.0:
		if _path_index >= _path.size():
			_arrive(Helper.get_structure_position(data.next_structure, true))
			return

		var target = _path[_path_index]
		var seg = target - _walker_pos
		var seg_len = seg.length()

		if seg_len < 0.0001:
			_path_index += 1
			continue

		var dir = seg / seg_len
		var advance = min(remaining, seg_len)

		_walker_pos += dir * advance
		_walker_dir = dir
		_distance_accum += advance
		remaining -= advance

		while _distance_accum >= _step_spacing:
			_distance_accum -= _step_spacing
			_spawn_walk_step()

		if advance >= seg_len:
			_path_index += 1
		else:
			break

func _spawn_walk_step() -> void:
	var is_left = (_step & 1) == 1
	var perp = _walker_dir.rotated(PI * 0.5)
	var coord_pos = _walker_pos + perp * (side_offset if is_left else -side_offset)
	_emit_footprint(is_left, coord_pos, _walker_dir.angle() + PI * 0.5)
	_step = (_step + 1) % total_footprints

func _arrive(new_center: Vector2) -> void:
	var step_angle = TAU / float(total_footprints)

	if _has_last_footprint:
		var theta_L = (_last_footprint_pos - new_center).angle()
		_circle_phase = fposmod(theta_L + step_angle * (1 - _step), TAU)
	else:
		var theta_w = (_walker_pos - new_center).angle()
		_circle_phase = fposmod(theta_w - _step * step_angle, TAU)

	# Атомарная передача эстафеты без ре-энтри через сигнал.
	data.advance()

	_center = new_center
	_timer = 0.0
	_state = State.CIRCLING
	_path = PackedVector2Array()
	_path_index = 0
#endregion

extends Node2D
class_name Footprint

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
var step_interval: float = 0.15#0.6
var fade_in: float = 0.08
var fade_hold: float = 0.4
var fade_out: float = 1.0
var side_offset: float = 6.0

@export var move_speed: float = 248.0#48.0
@export var curve_samples: int = 48
@export_range(0.2, 1.0) var curve_tension: float = 0.45

var _step: int = 0
var _timer: float = 0.0
var _state: Bozo.Footprint = Bozo.Footprint.CIRCLING
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

var _route_structures: Array = []


#region init
func connect_signals() -> void:
	data.structures_changed.connect(_on_structures_changed)
	_on_structures_changed()

func _on_structures_changed() -> void:
	if data == null or data.current_structure == null:
		visible = false
		_state = Bozo.Footprint.CIRCLING
		return

	visible = true

	if data.next_structure != null:
		if _state != Bozo.Footprint.MOVING:
			_begin_move()
	else:
		_center = Helper.get_structure_position(data.current_structure, true)
		position = _center
		_state = Bozo.Footprint.CIRCLING
#endregion

func _process(delta: float) -> void:
	match _state:
		Bozo.Footprint.CIRCLING:
			_timer += delta
			while _timer >= step_interval:
				_timer -= step_interval
				_spawn_circle_step()
		Bozo.Footprint.MOVING:
			_process_moving(delta)
		Bozo.Footprint.ROUTE:
			_process_route(delta)

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
	_state = Bozo.Footprint.MOVING

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
	_state = Bozo.Footprint.CIRCLING
	_path = PackedVector2Array()
	_path_index = 0
#endregion

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventKey and event.pressed and not event.echo and event.keycode == KEY_SPACE:
		start_route()
		get_viewport().set_input_as_handled()

func start_route() -> void:
	if data == null or data.mainland == null: return
	var route_data: RouteData = data.mainland.route
	if route_data == null: return

	var trods: Array = route_data.type_to_trods.get(route_data.selected_type, [])
	if trods.is_empty(): return
	update_route()

	var structures: Array = []
	for trod in trods:
		if trod == null or trod.structures.size() < 2: continue
		var s0: StructureData = trod.structures[0]
		var s1: StructureData = trod.structures[1]
		var a: StructureData = s0 if trod.is_clockwise else s1
		var b: StructureData = s1 if trod.is_clockwise else s0
		if structures.is_empty():
			structures.append(a)
		structures.append(b)

	if structures.size() < 2: return

	_route_structures = structures

	var t: float = _circle_phase + float(_step) * TAU / float(total_footprints)
	var pos_first: Vector2 = Helper.get_structure_position(structures[0], true)
	var p0: Vector2 = pos_first + Vector2(cos(t), sin(t)) * radius
	var d0: Vector2 = Vector2(-sin(t), cos(t))

	_build_route_path(structures, p0, d0)

	data.is_silent = true
	data.current_structure = structures[0]
	data.next_structure = null
	data.is_silent = false

	_walker_pos = p0
	_walker_dir = d0
	_step_spacing = max(1.0, (TAU * radius) / float(total_footprints))
	_distance_accum = _step_spacing
	_path_index = 1
	_timer = 0.0
	_state = Bozo.Footprint.ROUTE

func _build_route_path(structures: Array, p_start: Vector2, d_start: Vector2) -> void:
	var k: int = structures.size()

	# Узлы
	var node_positions: Array = [p_start]
	for i in range(1, k - 1):
		node_positions.append(Helper.get_structure_position(structures[i], true))

	var pos_last: Vector2 = Helper.get_structure_position(structures[k - 1], true)
	var pos_prev: Vector2 = Helper.get_structure_position(structures[k - 2], true)
	var approach: Vector2 = (pos_last - pos_prev).normalized()
	var p_end: Vector2 = pos_last + approach.rotated(-PI * 0.5) * radius
	node_positions.append(p_end)

	# Касательные: старт — из круга, промежуточные — по соседям, финиш — по подходу
	var node_tangents: Array = [d_start]
	for i in range(1, k - 1):
		var prev_pos: Vector2 = Helper.get_structure_position(structures[i - 1], true)
		var next_pos: Vector2 = Helper.get_structure_position(structures[i + 1], true)
		node_tangents.append((next_pos - prev_pos).normalized())
	node_tangents.append(approach)

	# Конкатенация Безье-сегментов в один _path
	_path = PackedVector2Array()
	_path.append(node_positions[0])
	for i in range(k - 1):
		var a: Vector2 = node_positions[i]
		var b: Vector2 = node_positions[i + 1]
		var ta: Vector2 = node_tangents[i]
		var tb: Vector2 = node_tangents[i + 1]
		var dist: float = a.distance_to(b)
		var tension: float = max(dist * curve_tension, 30.0)
		var cp1: Vector2 = a + ta * tension
		var cp2: Vector2 = b - tb * tension
		for j in range(1, curve_samples + 1):
			var u: float = float(j) / float(curve_samples)
			_path.append(_bezier(a, cp1, cp2, b, u))

func _advance_along_path(delta: float) -> bool:
	var remaining: float = move_speed * delta
	while remaining > 0.0:
		if _path_index >= _path.size():
			return true

		var target: Vector2 = _path[_path_index]
		var seg: Vector2 = target - _walker_pos
		var seg_len: float = seg.length()

		if seg_len < 0.0001:
			_path_index += 1
			continue

		var dir: Vector2 = seg / seg_len
		var advance: float = min(remaining, seg_len)

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
	return false

func _process_moving(delta: float) -> void:
	if _advance_along_path(delta):
		_arrive(Helper.get_structure_position(data.next_structure, true))

func _process_route(delta: float) -> void:
	if _advance_along_path(delta):
		_finish_route()

func _finish_route() -> void:
	if _route_structures.is_empty():
		_state = Bozo.Footprint.CIRCLING
		data.mainland.route.start_structure = data.mainland.footprint.current_structure
		return

	var last_structure: StructureData = _route_structures.back()
	var new_center: Vector2 = Helper.get_structure_position(last_structure, true)
	var step_angle: float = TAU / float(total_footprints)

	# Та же логика выравнивания фазы, что и в _arrive
	if _has_last_footprint:
		var theta_L: float = (_last_footprint_pos - new_center).angle()
		_circle_phase = fposmod(theta_L + step_angle * (1 - _step), TAU)
	else:
		var theta_w: float = (_walker_pos - new_center).angle()
		_circle_phase = fposmod(theta_w - _step * step_angle, TAU)

	# Атомарно фиксируем конечную структуру и уведомляем слушателей
	data.is_silent = true
	data.current_structure = last_structure
	data.next_structure = null
	data.is_silent = false
	data.structures_changed.emit()

	_center = new_center
	_timer = 0.0
	_state = Bozo.Footprint.CIRCLING
	_path = PackedVector2Array()
	_path_index = 0
	_route_structures.clear()
	data.mainland.route.start_structure = data.mainland.footprint.current_structure

func update_route() -> void:
	data.mainland.route.reset()
	data.mainland.route.trods_updated.emit()

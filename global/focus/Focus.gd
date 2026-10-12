extends Node

## Dims the screen and cuts holes over the nodes you aim at.
##
## Candidates register once. Structure, Slice, Eddy, Flux, Stair, Echo,
## Shadow, Stake and Hymn already do. A later node does the same, or
## drops a FocusMark on a Control (Master panels, buttons):
##
##	Focus.aim(structure_data)
##	Focus.aim_all([slice_data, stair_data], -1, -1, Focus.Shape.CIRCLE)
##	Focus.include(%SomeButton)
##	Focus.aim_rect(Rect2(position, size))
##	Focus.release()
##
## Holes follow the node, including through the mainland SubViewport.
## Clicks outside a hole are swallowed while a hole is on screen.


signal aimed
signal released

enum Shape {
	ROUNDED,
	CIRCLE,
}

const MAX_HOLES := 8
const VEIL_SHADER := preload("res://global/focus/veil.gdshader")

var dim_color := Color(0, 0, 0, 0.72)
var softness := 22.0
var default_padding := 18.0
var default_radius := 14.0
## 0 snaps the hole to the node. Higher values ease it toward the node.
var follow := 0.0
var fade_speed := 4.0
var block_outside := true

var _layer: CanvasLayer
var _veil: ColorRect
var _catcher: Node
var _promote_queued := false
var _keys := {}
var _pads := {}
var _radii := {}
var _shapes := {}
var _holes: Array = []
var _pending: Array = []
var _rects := PackedVector4Array()
var _radii_px := PackedFloat32Array()
var _draw_count := 0
var _passthrough: Array[Control] = []
var _fade := 0.0
var _fade_target := 0.0


class Catcher extends Node:
	func _input(event: InputEvent) -> void:
		Focus._catch(event)


class Hole extends RefCounted:
	var item: CanvasItem
	var fixed := Rect2()
	var use_fixed := false
	var padding := 0.0
	var radius := 0.0
	var shape := 0
	var rect := Rect2()
	var fresh := true


func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	_rects.resize(MAX_HOLES)
	_radii_px.resize(MAX_HOLES)

	_layer = CanvasLayer.new()
	_layer.layer = 120
	_layer.visible = false
	_layer.process_mode = Node.PROCESS_MODE_ALWAYS
	add_child(_layer)

	_veil = ColorRect.new()
	_veil.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_veil.color = Color.WHITE
	var material := ShaderMaterial.new()
	material.shader = VEIL_SHADER
	_veil.material = material
	_layer.add_child(_veil)

	_fit_veil()
	_push_shader()
	set_process(false)

	# _input walks the tree from the bottom. Keep the catcher last so a click
	# outside a hole is swallowed before mainland and the other screens see it.
	_catcher = Catcher.new()
	_catcher.name = "FocusCatcher"
	_catcher.process_mode = Node.PROCESS_MODE_ALWAYS
	get_tree().node_added.connect(_queue_promote)
	_promote_queued = true
	_promote.call_deferred()


func is_active() -> bool:
	return _fade > 0.0 or not _holes.is_empty() or not _pending.is_empty()


#region aim
func register(key, item: CanvasItem, padding: float = -1.0, radius: float = -1.0, shape: int = -1) -> void:
	if key == null or item == null:
		return

	_keys[key] = item
	if padding >= 0.0:
		_pads[key] = padding
	if radius >= 0.0:
		_radii[key] = radius
	if shape >= 0:
		_shapes[key] = shape
	_claim_pending(key, item)


func unregister(key) -> void:
	_keys.erase(key)
	_pads.erase(key)
	_radii.erase(key)
	_shapes.erase(key)

	var kept: Array = []
	for entry in _pending:
		if entry["key"] != key:
			kept.append(entry)
	_pending = kept


func aimed_rect() -> Rect2:
	if _draw_count <= 0:
		return Rect2()
	var packed := _rects[0]
	return Rect2(packed.x, packed.y, packed.z, packed.w)


func aim(target, padding: float = -1.0, radius: float = -1.0, shape: int = -1) -> void:
	aim_all([target], padding, radius, shape)


func aim_all(targets: Array, padding: float = -1.0, radius: float = -1.0, shape: int = -1) -> void:
	_replace()
	for target in targets:
		_add_target(target, padding, radius, shape)
	_finish()
	if not _holes.is_empty() or not _pending.is_empty():
		aimed.emit()


func aim_rect(rect: Rect2, padding: float = -1.0, radius: float = -1.0, shape: int = -1) -> void:
	_replace()
	_add_fixed(rect, padding, radius, shape)
	_finish()
	if not _holes.is_empty():
		aimed.emit()


func include(target, padding: float = -1.0, radius: float = -1.0, shape: int = -1) -> void:
	_add_target(target, padding, radius, shape)
	_finish()


func include_rect(rect: Rect2, padding: float = -1.0, radius: float = -1.0, shape: int = -1) -> void:
	_add_fixed(rect, padding, radius, shape)
	_finish()


func allow(control: Control) -> void:
	if control != null and not _passthrough.has(control):
		_passthrough.append(control)


func disallow(control: Control) -> void:
	_passthrough.erase(control)


func release() -> void:
	var active := is_active()
	_holes.clear()
	_pending.clear()
	if not active:
		return
	_fade_target = 0.0
	set_process(true)
	released.emit()
#endregion


#region input
func _queue_promote(_node: Node) -> void:
	if _node == _catcher or _promote_queued:
		return
	_promote_queued = true
	_promote.call_deferred()


func _promote() -> void:
	_promote_queued = false
	if not is_instance_valid(_catcher):
		return

	var root := get_tree().root
	if _catcher.get_parent() != root:
		root.add_child(_catcher)

	var last := root.get_child_count() - 1
	if root.get_child(last) != _catcher:
		root.move_child(_catcher, last)


func _catch(event: InputEvent) -> void:
	if not block_outside or _draw_count == 0:
		return
	if _fade <= 0.0 and _fade_target <= 0.0:
		return
	if not event is InputEventMouseButton:
		return
	var point := (event as InputEventMouseButton).position
	if _hits(point) or _over_passthrough(point):
		return
	get_viewport().set_input_as_handled()


func _over_passthrough(point: Vector2) -> bool:
	for i in range(_passthrough.size() - 1, -1, -1):
		var control := _passthrough[i]
		if not is_instance_valid(control):
			_passthrough.remove_at(i)
			continue
		if control.is_visible_in_tree() and control.get_global_rect().has_point(point):
			return true
	return false


func _process(delta: float) -> void:
	_purge_invalid_holes()

	if _holes.is_empty():
		_fade_target = 0.0
	else:
		_sync(delta)
		_fade_target = 0.0 if _draw_count == 0 else 1.0

	_fade = move_toward(_fade, _fade_target, delta * fade_speed)

	if _fade <= 0.0 and _holes.is_empty():
		_draw_count = 0
		_layer.visible = false
		set_process(false)
		return

	_layer.visible = _fade > 0.0
	if _layer.visible:
		_fit_veil()
		_push_shader()
#endregion


#region holes
func _replace() -> void:
	_holes.clear()
	_pending.clear()


func _add_target(target, padding: float, radius: float, shape: int) -> void:
	if target == null or not _has_room():
		return

	var pad := _padding_of(target, padding)
	var rad := _radius_of(target, radius)
	var kind := _shape_of(target, shape)
	var item := _resolve_item(target)

	if item == null:
		_pending.append({key = target, padding = pad, radius = rad, shape = kind})
		return

	_add_hole(item, pad, rad, kind)


func _add_fixed(rect: Rect2, padding: float, radius: float, shape: int) -> void:
	if not rect.has_area() or not _has_room():
		return

	var hole := Hole.new()
	hole.use_fixed = true
	hole.fixed = rect
	hole.padding = padding if padding >= 0.0 else default_padding
	hole.radius = radius if radius >= 0.0 else default_radius
	hole.shape = shape if shape >= 0 else Shape.ROUNDED
	_holes.append(hole)


func _add_hole(item: CanvasItem, padding: float, radius: float, shape: int) -> void:
	var hole := Hole.new()
	hole.item = item
	hole.padding = padding
	hole.radius = radius
	hole.shape = shape
	_holes.append(hole)


func _has_room() -> bool:
	if _holes.size() + _pending.size() < MAX_HOLES:
		return true
	push_warning("Focus can show at most %d regions." % MAX_HOLES)
	return false


func _claim_pending(key, item: CanvasItem) -> void:
	var kept: Array = []
	var claimed := false

	for entry in _pending:
		if entry["key"] == key:
			_add_hole(item, entry["padding"], entry["radius"], entry["shape"])
			claimed = true
		else:
			kept.append(entry)

	_pending = kept
	if claimed:
		_finish()


func _finish() -> void:
	if _holes.is_empty():
		return
	_sync(0.0)
	set_process(true)
	_fade_target = 0.0 if _draw_count == 0 else 1.0
	if _fade_target <= 0.0:
		return
	_layer.visible = true
	_fit_veil()
	_push_shader()


func _resolve_item(target) -> CanvasItem:
	if target is CanvasItem and is_instance_valid(target):
		return target
	if not _keys.has(target):
		return null

	var item = _keys[target]
	if not is_instance_valid(item):
		unregister(target)
		return null
	return item


func _padding_of(target, padding: float) -> float:
	if padding >= 0.0:
		return padding
	if _pads.has(target):
		return _pads[target]
	return default_padding


func _radius_of(target, radius: float) -> float:
	if radius >= 0.0:
		return radius
	if _radii.has(target):
		return _radii[target]
	return default_radius


func _shape_of(target, shape: int) -> int:
	if shape >= 0:
		return shape
	if _shapes.has(target):
		return int(_shapes[target])
	return Shape.ROUNDED


func _purge_invalid_holes() -> void:
	for i in range(_holes.size() - 1, -1, -1):
		var hole: Hole = _holes[i]
		if hole.use_fixed:
			continue
		if not is_instance_valid(hole.item):
			_holes.remove_at(i)


func _sync(delta: float) -> void:
	_draw_count = 0

	for hole in _holes:
		var target: Rect2 = _styled_rect(hole)
		if not target.has_area():
			hole.rect = Rect2()
			hole.fresh = true
			continue

		if hole.fresh or follow <= 0.0:
			hole.rect = target
			hole.fresh = false
		else:
			var t := 1.0 - exp(-follow * delta)
			hole.rect.position = hole.rect.position.lerp(target.position, t)
			hole.rect.size = hole.rect.size.lerp(target.size, t)

		if _draw_count >= MAX_HOLES:
			break
		_rects[_draw_count] = Vector4(hole.rect.position.x, hole.rect.position.y, hole.rect.size.x, hole.rect.size.y)
		_radii_px[_draw_count] = _pixel_radius(hole)
		_draw_count += 1


func _styled_rect(hole: Hole) -> Rect2:
	var rect := hole.fixed if hole.use_fixed else screen_rect(hole.item)
	if not rect.has_area():
		return Rect2()

	rect = rect.grow(hole.padding)
	if hole.shape == Shape.CIRCLE:
		var side := maxf(rect.size.x, rect.size.y)
		var center := rect.get_center()
		rect = Rect2(center - Vector2(side, side) * 0.5, Vector2(side, side))
	return rect


func _pixel_radius(hole: Hole) -> float:
	var limit := minf(hole.rect.size.x, hole.rect.size.y) * 0.5
	if hole.shape == Shape.CIRCLE:
		return limit
	return minf(hole.radius, limit)


func _hits(point: Vector2) -> bool:
	for i in _draw_count:
		var packed := _rects[i]
		var rect := Rect2(packed.x, packed.y, packed.z, packed.w)
		if _contains(rect, _radii_px[i], point):
			return true
	return false


func _contains(rect: Rect2, radius: float, point: Vector2) -> bool:
	var half := rect.size * 0.5
	var center := rect.position + half
	var r := minf(radius, minf(half.x, half.y))
	var q := (point - center).abs() - half + Vector2(r, r)
	var dist := q.max(Vector2.ZERO).length() + minf(maxf(q.x, q.y), 0.0) - r
	return dist <= 0.0
#endregion


#region bounds
func screen_rect(item: CanvasItem) -> Rect2:
	if not is_instance_valid(item) or not item.is_inside_tree() or not item.is_visible_in_tree():
		return Rect2()

	var local := _local_rect(item)
	if not local.has_area():
		return Rect2()

	var viewport := item.get_viewport()
	if viewport == null:
		return Rect2()

	var on_canvas := _transform_rect(item.get_global_transform_with_canvas(), local)
	return _map_to_root(on_canvas, viewport)


func _local_rect(item: CanvasItem) -> Rect2:
	if item is Control:
		return Rect2(Vector2.ZERO, (item as Control).size)

	var merged := Rect2()
	var has := false
	var own := _own_rect(item)

	if own.has_area():
		merged = own
		has = true

	for child in item.get_children():
		if not child is CanvasItem:
			continue
		var canvas := child as CanvasItem
		if not canvas.visible:
			continue
		var child_rect := _local_rect(canvas)
		if not child_rect.has_area():
			continue
		var placed := _transform_rect(canvas.get_transform(), child_rect)
		merged = placed if not has else merged.merge(placed)
		has = true

	return merged if has else Rect2()


func _own_rect(item: CanvasItem) -> Rect2:
	if item is Sprite2D:
		return (item as Sprite2D).get_rect()
	if item is Polygon2D:
		var poly := item as Polygon2D
		return _points_rect(poly.polygon, poly.offset)
	if item is Line2D:
		var line := item as Line2D
		var rect := _points_rect(line.points)
		if line.points.size() > 0:
			return rect.grow(line.width * 0.5)
	return Rect2()


func _points_rect(points: PackedVector2Array, offset := Vector2.ZERO) -> Rect2:
	if points.is_empty():
		return Rect2()

	var rect := Rect2(points[0] + offset, Vector2.ZERO)
	for i in range(1, points.size()):
		rect = rect.expand(points[i] + offset)
	return rect


func _map_to_root(rect: Rect2, viewport: Viewport) -> Rect2:
	var root := get_tree().root
	var guard := 0

	while viewport != root and guard < 8:
		guard += 1
		var parent := viewport.get_parent()
		if not parent is SubViewportContainer:
			break

		var container := parent as SubViewportContainer
		var vp_size := Vector2(viewport.size)
		if vp_size.x <= 0.0 or vp_size.y <= 0.0:
			return Rect2()

		var bounds := Rect2(Vector2.ZERO, vp_size)
		if not rect.intersects(bounds):
			return Rect2()
		rect = rect.intersection(bounds)

		var container_rect := container.get_global_rect()
		var scale := Vector2.ONE
		if container.stretch and container_rect.size.x > 0.0 and container_rect.size.y > 0.0:
			scale = container_rect.size / vp_size
		rect = Rect2(container_rect.position + rect.position * scale, rect.size * scale)
		viewport = container.get_viewport()

	return rect


func _transform_rect(xform: Transform2D, rect: Rect2) -> Rect2:
	var a := xform * rect.position
	var b := xform * (rect.position + Vector2(rect.size.x, 0.0))
	var c := xform * (rect.position + rect.size)
	var d := xform * (rect.position + Vector2(0.0, rect.size.y))
	var out := Rect2(a, Vector2.ZERO)
	out = out.expand(b)
	out = out.expand(c)
	out = out.expand(d)
	return out
#endregion


#region veil
func _fit_veil() -> void:
	var rect := get_viewport().get_visible_rect()
	_veil.position = rect.position
	_veil.size = rect.size


func _push_shader() -> void:
	var material := _veil.material as ShaderMaterial
	var color := dim_color
	color.a *= _fade
	material.set_shader_parameter("dim_color", color)
	material.set_shader_parameter("hole_count", _draw_count)
	material.set_shader_parameter("hole_rects", _rects)
	material.set_shader_parameter("hole_radii", _radii_px)
	material.set_shader_parameter("softness", softness)
	material.set_shader_parameter("veil_origin", _veil.position)
	material.set_shader_parameter("veil_size", _veil.size)
#endregion

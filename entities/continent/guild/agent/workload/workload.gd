class_name Workload
extends PanelContainer


var overtime_scene = preload('uid://ch6w8tyhq8jts')

var data: WorkloadData:
	set(value_):
		data = value_
		init_overtimes()
		connect_signals()

var overtime_tween: Tween
var is_initialized := false
var visual_boundary: float = 0.0


#region init
func init_overtimes() -> void:
	Helper.clear_children(%Overtimes)
	for _i in Catalog.OVERTIME_GRID.x:
		for _j in Catalog.OVERTIME_GRID.y:
			add_overtime(Vector2i(_i, _j))

func add_overtime(coord_: Vector2i) -> void:
	var overtime = overtime_scene.instantiate()
	%Overtimes.add_child(overtime)
	overtime.coord = coord_

func connect_signals() -> void:
	if not data.overtime_changed.is_connected(_on_overtime_changed):
		data.overtime_changed.connect(_on_overtime_changed)
	
	_on_overtime_changed()
#endregion

#region overtime
func _on_overtime_changed() -> void:
	if not is_initialized:
		is_initialized = true
		apply_overtime_state(float(data.next_overtime), data.next_overtime)
		return

	animate_overtime(data.next_overtime)

## Мгновенно выставляет видимость по «границе»
func apply_overtime_state(boundary: float, current_overtime_) -> void:
	visual_boundary = boundary
	var overtimes := %Overtimes.get_children()
	
	for _i in overtimes.size():
		overtimes[_i].visible = _i < boundary
	
	data.current_overtime = current_overtime_

## Анимирует «перещёлкивание» visible от текущего визуального состояния до target_idx
func animate_overtime(target_idx: int) -> void:
	var overtimes := %Overtimes.get_children()
	var from_boundary: float = visual_boundary
	var to_boundary: float = float(target_idx)

	if overtime_tween and overtime_tween.is_valid():
		overtime_tween.kill()

	if is_equal_approx(from_boundary, to_boundary):
		apply_overtime_state(to_boundary, target_idx)
		return

	var duration = Gear.workloads[Gear.tempo]
	overtime_tween = create_tween().set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	overtime_tween.tween_method(
		func(v: float) -> void:
			visual_boundary = v
			for i in overtimes.size():
				overtimes[i].visible = i < v,
		from_boundary,
		to_boundary,
		duration
	)
	overtime_tween.tween_callback(func() -> void:
		apply_overtime_state(to_boundary, target_idx)
	)
#endregion

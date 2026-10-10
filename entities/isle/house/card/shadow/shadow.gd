class_name Shadow
extends PanelContainer


var data: ShadowData:
	set(value_):
		data = value_
		
		connect_signals()
		connect_datas()
		update_colors()

@export var card: Card

var expand_tween: Tween
var cant_tween: Tween
var flip_tween: Tween


#region init
func connect_signals() -> void:
	data.is_perished.connect(_on_perished)


func _on_perished() -> void:
	card.is_face_echo = true
	expand_out()

func connect_datas() -> void:
	%TopPressure.data = data.pressure
	%BottomPressure.data = data.pressure
	%TopShade.data = data.shade
	%BottomShade.data = data.shade

func update_colors() -> void:
	var color = Digest.matter_to_color[data.echo.soul.matter]
	%Border.get_theme_stylebox("panel").border_color = color
	%Top.get_theme_stylebox("panel").bg_color = color
	%Bottom.get_theme_stylebox("panel").bg_color = color
#endregion

#region animation
func expand_in() -> void:
	var duration = Gear.expands[Gear.tempo]
	
	expand_tween = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CIRC).set_parallel(true)
	expand_tween.tween_property(self, "size:y", Catalog.SHADOW_SIZE.y, duration)
	expand_tween.tween_property(self, "offset_transform_position:y", 0, duration)
	
	await expand_tween.finished
	
	duration = Gear.cants[Gear.tempo]
	
	cant_tween = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CIRC).set_parallel(true)
	cant_tween.tween_property(self, "offset_transform_rotation", PI / 2, duration)
	cant_tween.tween_property(%BottomShade, "offset_transform_rotation", -PI / 2, duration)
	cant_tween.tween_property(%TopShade, "offset_transform_rotation", -PI / 2, duration)
	cant_tween.tween_property(%BottomPressure, "offset_transform_rotation", -PI / 2, duration)
	cant_tween.tween_property(%TopPressure, "offset_transform_rotation", -PI / 2, duration)

func expand_out() -> void:
	var duration = Gear.cants[Gear.tempo]
	
	if cant_tween and cant_tween.is_running():
		cant_tween.kill()
	
	cant_tween = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CIRC).set_parallel(true)
	cant_tween.tween_property(self, "offset_transform_rotation", 0, duration)
	cant_tween.tween_property(%TopShade, "offset_transform_rotation", 0, duration)
	cant_tween.tween_property(%BottomShade, "offset_transform_rotation", 0, duration)
	cant_tween.tween_property(%BottomPressure, "offset_transform_rotation", 0, duration)
	cant_tween.tween_property(%TopPressure, "offset_transform_rotation", 0, duration)
	
	await cant_tween.finished
	cant_tween.kill()
	
	duration = Gear.expands[Gear.tempo]
	
	expand_tween = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CIRC).set_parallel(true)
	expand_tween.tween_property(self, "size:y", Catalog.ECHO_SIZE.y, duration)
	var y = -(Catalog.ECHO_SIZE.y - Catalog.SHADOW_SIZE.y) * 0.5
	expand_tween.tween_property(self, "offset_transform_position:y", y, duration)
	
	await expand_tween.finished
	expand_tween.kill()
	
	card.flip_on_echo()

func rotate_textures(angle_: float) -> void:
	offset_transform_rotation = angle_
	%TopShade.offset_transform_rotation = -angle_
	%BottomShade.offset_transform_rotation = -angle_
	%TopPressure.offset_transform_rotation = -angle_
	%BottomPressure.offset_transform_rotation = -angle_
#endregion

func process_click() -> void:
	if Arbitrator.current_phase.type != Bozo.Phase.DECISION: return
	var local_mouse_pos = get_local_mouse_position()
	var rect = Rect2(
		Vector2.ZERO,
		Vector2(Catalog.SHADOW_SIZE.x, Catalog.SHADOW_SIZE.y)
	)

	var is_inside = rect.has_point(local_mouse_pos)
	
	if is_inside:
		var attack_shadow = ActionAttackShadow.new(data)
		Arbitrator.current_phase.try_execute_action(attack_shadow)

func _on_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		process_click()

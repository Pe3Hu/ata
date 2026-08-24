class_name Shadow
extends PanelContainer


var data: ShadowData:
	set(value_):
		data = value_
		
		connect_signals()
		update_colors()

@export var card: Card
@export var top_shade: TextureRect
@export var bottom_shade: TextureRect

var expand_tween: Tween
var cant_tween: Tween
var flip_tween: Tween


#region init
func connect_signals() -> void:
	data.shade_changed.connect(_on_shade_changed)
	_on_shade_changed()

func _on_shade_changed() -> void:
	top_shade.texture = load("res://entities/dice/images/%d.png" % data.current_shade)
	bottom_shade.texture = load("res://entities/dice/images/%d.png" % data.current_shade)

func update_colors() -> void:
	var color = Digest.matter_to_color[data.stamp.origin.matter]
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
	cant_tween.tween_property(bottom_shade, "offset_transform_rotation", -PI / 2, duration)
	cant_tween.tween_property(top_shade, "offset_transform_rotation", -PI / 2, duration)

func expand_out() -> void:
	var duration = Gear.cants[Gear.tempo]
	
	if cant_tween and cant_tween.is_running():
		cant_tween.kill()
	
	cant_tween = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CIRC).set_parallel(true)
	cant_tween.tween_property(self, "offset_transform_rotation", 0, duration)
	cant_tween.tween_property(top_shade, "offset_transform_rotation", 0, duration)
	cant_tween.tween_property(bottom_shade, "offset_transform_rotation", 0, duration)
	
	await cant_tween.finished
	cant_tween.kill()
	
	duration = Gear.expands[Gear.tempo]
	
	expand_tween = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CIRC).set_parallel(true)
	expand_tween.tween_property(self, "size:y", Catalog.STAMP_SIZE.y, duration)
	var y = -(Catalog.STAMP_SIZE.y - Catalog.SHADOW_SIZE.y) * 0.5
	expand_tween.tween_property(self, "offset_transform_position:y", y, duration)
	
	await expand_tween.finished
	expand_tween.kill()
	
	card.flip_on_stamp()
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
		var attack_shadow = ActionAttackShadow.new(data, card.room)
		Arbitrator.current_phase.try_execute_action(attack_shadow)

func _on_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		process_click()

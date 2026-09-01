class_name Card
extends Control


@export var room: Room
@export var stamp: Stamp
@export var shadow: Shadow

@export var angle_min: float = -0.0
@export var angle_max: float = 0.0

@export var min_size_x_default: float:
	get:
		return stamp.size.x
@export var min_size_x_hover: float:
	get:
		return stamp.size.x + abs(Catalog.JOINT_OFFEST) * 2

var duration_shift: float = 0

var hover_tween: Tween
var appear_tween: Tween
var activate_tween: Tween
var flip_tween: Tween

var is_face_stamp: bool = true



#region init
func _ready() -> void:
	stamp.border.self_modulate.a = 0.0
	pivot_offset_ratio = Vector2(0.5, 0.5)
	pivot_offset = size / 2
	
	stamp.mouse_entered.connect(hover)
	stamp.mouse_exited.connect(
		func() -> void:
			if !stamp.get_global_rect().has_point(get_global_mouse_position()):
				unhover()
	)
	
	custom_minimum_size.x = min_size_x_default
	position.x = 0
	first_appear()

func first_appear() -> void:
	offset_transform_position.x = Catalog.CARD_APPEAR_DISTANCE
	rng_duration_shift()
	appear()
	Arbitrator.queue_an_animation(appear_tween)
	await appear_tween.finished
	duration_shift = 0

func rng_duration_shift() -> void:
	duration_shift = Gear.appears[Gear.tempo] * Helper.rng.randf_range(Gear.min_appear_factor, Gear.max_appear_factor)

func appear() -> void:
	if appear_tween and appear_tween.is_running(): return
	visible = true
	appear_tween = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_SINE)
	appear_tween.parallel().tween_property(self, "offset_transform_position:x", 0.0, Gear.appears[Gear.tempo] + duration_shift)

	await appear_tween.finished
	mouse_filter = Control.MOUSE_FILTER_PASS
	stamp.mouse_filter = Control.MOUSE_FILTER_PASS

func disappear(is_last_: bool = false) -> void:
	if appear_tween and appear_tween.is_running(): return
	appear_tween = create_tween().set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_SINE)#TRANS_CIRC
	appear_tween.parallel().tween_property(self, "offset_transform_position:x", Catalog.CARD_APPEAR_DISTANCE, Gear.appears[Gear.tempo])
	await appear_tween.finished
	room.close_up_cards(self)
	
	if is_last_:
		get_parent().remove_child(self)
		queue_free()

func last_disappear() -> void:
	rng_duration_shift()
	disappear(true)
	
	Arbitrator.queue_an_animation(appear_tween)
#endregion

#region hover
func hover() -> void:
	if appear_tween and appear_tween.is_running(): return
	if room.shift_tween and room.shift_tween.is_running(): return
	#if room.current_card == self: return
	if hover_tween and hover_tween.is_running(): return
	if room.data.type == Bozo.Room.PARLOR: return
	if stamp.data.is_locked: return
	
	z_index = 1
	var current_x = stamp.position.x
	
	if room.current_card and room.current_card != self:
		room.current_card.unhover()
	
	room.current_card = self
	
	#if hover_tween and hover_tween.is_running():
	#	hover_tween.kill()
	
	hover_tween = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC).set_parallel(true)
	hover_tween.tween_property(stamp, "offset_transform_position:y", -Catalog.STAMP_SIDE_HEIGHT, 0.15)
	hover_tween.tween_property(stamp.border, "self_modulate:a", 1.0, 0.1)
	hover_tween.tween_property(self, "custom_minimum_size:x", min_size_x_hover, 0.2)
	hover_tween.tween_property(stamp, "position:x", current_x + (min_size_x_hover - min_size_x_default) / 2, 0.2)
	
	await hover_tween.finished
	
	var local_mouse_pos = get_global_mouse_position()
	var is_inside = stamp.get_global_rect().has_point(local_mouse_pos)
	
	if not is_inside:
		unhover()

func unhover() -> void:
	if appear_tween and appear_tween.is_running(): return
	if hover_tween and hover_tween.is_running(): return
	if room.data.type == Bozo.Room.PARLOR: return
	if stamp.data.is_locked: return
	z_index = 0
	
	if room.shift_tween and room.shift_tween.is_running():
		z_index = 1
	
	if room.current_card == self:
		room.current_card = null
	
	#if hover_tween and hover_tween.is_running():
	#	hover_tween.kill()
	
	hover_tween = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC).set_parallel(true)
	hover_tween.tween_property(stamp, "offset_transform_position:y", 0, 0.15)
	hover_tween.tween_property(stamp.border, "self_modulate:a", 0.0, 0.1)
	hover_tween.tween_property(self, "custom_minimum_size:x", min_size_x_default, 0.25)
	hover_tween.tween_property(stamp, "position:x", 0, 0.25)
	
	await hover_tween.finished
	
	var local_mouse_pos = get_global_mouse_position()
	var is_inside = stamp.get_global_rect().has_point(local_mouse_pos)
	
	if is_inside:
		hover()
#endregion

#region activate
func spoil() -> void:
	mouse_filter = Control.MOUSE_FILTER_IGNORE
	stamp.mouse_filter = Control.MOUSE_FILTER_IGNORE
	unhover()
	await hover_tween.finished
	disappear()
	await appear_tween.finished

func activate(is_fol: bool = true) -> void:
	if is_fol and not room.house.room_to_fol.has(room): return
	if not is_fol and not room.house.room_to_ere.has(room): return
	if not room.house.active_tweens.is_empty(): return
	unhover()
	
	var next_room: Room
	
	if is_fol:
		next_room = room.house.room_to_fol[room]
	else:
		next_room = room.house.room_to_ere[room]
	
	var target_global = await next_room.get_card_target(self)
	var target_offset = target_global - global_position

	offset_transform_position = Vector2.ZERO
	room.jalousie(self)
	next_room.slide_away()
	var duration = Gear.jalousies[Gear.tempo]
	
	activate_tween = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CIRC).set_parallel(true)
	activate_tween.tween_property(self, "offset_transform_position", target_offset, duration)
	room.house.active_tweens.append(activate_tween)
	
	await activate_tween.finished
	finish_activate(is_fol)
	z_index = 0

func finish_activate(is_fol: bool = true) -> void:
	room.house.on_tween_finished(activate_tween)
	var next_room: Room
	
	if is_fol:
		next_room = room.house.room_to_fol[room]
	else:
		next_room = room.house.room_to_ere[room]
	
	var previous_room = room
	next_room.plus_card(self)
	previous_room.reset_offsets()
	next_room.reset_offsets()
#endregion

#region flip
func flip_on_shadow() -> void:
	var duration = Gear.flips[Gear.tempo]
	
	if flip_tween and flip_tween.is_running():
		flip_tween.kill()
	
	flip_tween = create_tween().set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_CIRC).set_parallel(true)
	flip_tween.tween_property(stamp, "offset_transform_scale:x", 0.0, duration)
	
	await flip_tween.finished
	
	flip_tween = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CIRC).set_parallel(true)
	flip_tween.tween_property(shadow, "offset_transform_scale:x", 1.0, duration)
	
	await flip_tween.finished
	
	shadow.expand_in()

func flip_on_stamp() -> void:
	var duration = Gear.flips[Gear.tempo]
	z_index = 10
	
	if flip_tween and flip_tween.is_running():
		flip_tween.kill()
	
	flip_tween = create_tween().set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_CIRC).set_parallel(true)
	flip_tween.tween_property(shadow, "offset_transform_scale:x", 0.0, duration)
	
	await flip_tween.finished
	
	flip_tween = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CIRC).set_parallel(true)
	flip_tween.tween_property(stamp, "offset_transform_scale:x", 1.0, duration)
	
	await flip_tween.finished
	
	activate()

func skip_on_shadow() -> void:
	is_face_stamp = false
	
	stamp.offset_transform_scale.x = 0
	shadow.offset_transform_scale.x = 1
	
	shadow.size.y = Catalog.SHADOW_SIZE.y
	shadow.offset_transform_position.y = 0
	
	shadow.offset_transform_rotation = PI / 2
	shadow.top_shade.offset_transform_rotation = -PI / 2
	shadow.bottom_shade.offset_transform_rotation = -PI / 2

func skip_on_stamp() -> void:
	is_face_stamp = true
	
	stamp.offset_transform_scale.x = 1
	shadow.offset_transform_scale.x = 0
	
	shadow.size.y = Catalog.STAMP_SIZE.y
	shadow.offset_transform_position.y = -(Catalog.STAMP_SIZE.y - Catalog.SHADOW_SIZE.y) * 0.5
	
	shadow.offset_transform_rotation = 0
	shadow.top_shade.offset_transform_rotation = 0
	shadow.bottom_shade.offset_transform_rotation = 0

func switch_face() -> void:
	if is_face_stamp:
		flip_on_shadow()
	else:
		shadow.expand_out()
	
	is_face_stamp = !is_face_stamp
#endregion

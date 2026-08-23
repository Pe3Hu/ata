class_name Card
extends Control


@export var room: Room
@export var stamp: Stamp

@export var angle_min: float = -0.0
@export var angle_max: float = 0.0

@export var min_size_x_default: float:
	get:
		return stamp.size.x
@export var min_size_x_hover: float:
	get:
		return stamp.size.x * 1.2

var duration_shift: float = 0

var hover_tween: Tween
var appear_tween: Tween
var activate_tween: Tween


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
	stamp.offset_transform_position_ratio.y = 1.25
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
	#custom_minimum_size.x = min_size_x_default # Setting it directly results in snapping instead of smooth movement
	appear_tween = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_SINE)
	#appear_tween.tween_property(self, "custom_minimum_size:x", min_size_x_default, 0.25)
	appear_tween.parallel().tween_property(stamp, "offset_transform_position_ratio:y", 0.0, Gear.appears[Gear.tempo] + duration_shift)

	await appear_tween.finished
	mouse_filter = Control.MOUSE_FILTER_PASS
	stamp.mouse_filter = Control.MOUSE_FILTER_PASS

func disappear() -> void:
	if appear_tween and appear_tween.is_running(): return
	appear_tween = create_tween().set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_SINE)#TRANS_CIRC
	#appear_tween.tween_property(self, "custom_minimum_size:x", 0.0, 0.2)
	appear_tween.parallel().tween_property(stamp, "offset_transform_position_ratio:y", 1.25, Gear.appears[Gear.tempo])
	await appear_tween.finished
	room.close_up_cards(self)

func last_disappear() -> void:
	rng_duration_shift()
	disappear()
	
	Arbitrator.queue_an_animation(appear_tween)
#endregion

#region hover
func hover() -> void:
	if appear_tween and appear_tween.is_running(): return
	if room.shift_tween and room.shift_tween.is_running(): return
	z_index = 1
	var current_x = stamp.position.x
	
	if room.current_card and room.current_card != self:
		room.current_card.unhover()
	
	room.current_card = self
	
	if hover_tween and hover_tween.is_running():
		hover_tween.kill()
	
	hover_tween = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC).set_parallel(true)
	hover_tween.tween_property(stamp, "offset_transform_scale", Vector2.ONE * 1.2, 0.1)
	hover_tween.tween_property(stamp, "offset_transform_rotation", 0.0, 0.1)
	hover_tween.tween_property(stamp, "offset_transform_position_ratio:y", -0.25, 0.15)
	hover_tween.tween_property(stamp.border, "self_modulate:a", 1.0, 0.1)
	hover_tween.tween_property(self, "custom_minimum_size:x", min_size_x_hover, 0.2).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)
	hover_tween.tween_property(stamp, "position:x", current_x + (min_size_x_hover - min_size_x_default) / 2, 0.2).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)

func unhover() -> void:
	if appear_tween and appear_tween.is_running(): return
	z_index = 0
	
	if room.current_card == self:
		room.current_card = null
	
	if room.shift_tween and room.shift_tween.is_running():
		z_index = 1
	
	if hover_tween and hover_tween.is_running():
		hover_tween.kill()
	
	hover_tween = create_tween().set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_CUBIC).set_parallel(true)
	hover_tween.tween_property(stamp, "offset_transform_scale", Vector2.ONE, 0.2)
	hover_tween.tween_property(stamp, "offset_transform_position_ratio:y", 0.0, 0.25)
	hover_tween.tween_property(stamp.border, "self_modulate:a", 0.0, 0.1)
	hover_tween.tween_property(self, "custom_minimum_size:x", min_size_x_default, 0.25).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)
	hover_tween.tween_property(stamp, "position:x", 0, 0.25).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)

#endregion

func spoil() -> void:
	mouse_filter = Control.MOUSE_FILTER_IGNORE
	stamp.mouse_filter = Control.MOUSE_FILTER_IGNORE
	unhover()
	await hover_tween.finished
	disappear()
	await appear_tween.finished

func activate() -> void:
	if not room.atheneum.room_to_fol.has(room): return
	unhover()
	
	var fol_room = room.atheneum.room_to_fol[room]
	var target_global = await fol_room.get_card_target(self)
	var target_offset = target_global - global_position

	offset_transform_position = Vector2.ZERO
	room.jalousie(self)
	fol_room.slide_away()
	var duration = Gear.jalousies[Gear.tempo]
	
	activate_tween = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CIRC).set_parallel(true)
	activate_tween.tween_property(self, "offset_transform_position", target_offset, duration)
	room.atheneum.active_tweens.append(activate_tween)
	activate_tween.tween_callback(room.atheneum.on_tween_finished.bind(activate_tween))
	
	await activate_tween.finished
	room.atheneum.active_card = self
	room.atheneum.active_room = fol_room
	
	if room.atheneum.active_tweens.is_empty():
		room.atheneum.finish_activate(self, fol_room)

func deactivate() -> void:
	if not room.atheneum.room_to_ere.has(room): return
	unhover()
	
	var ere_room = room.atheneum.room_to_ere[room]
	var target_global = await ere_room.get_card_target(self)
	var target_offset = target_global - global_position

	offset_transform_position = Vector2.ZERO
	room.jalousie(self)
	ere_room.slide_away()
	var duration = Gear.jalousies[Gear.tempo]
	
	activate_tween = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CIRC).set_parallel(true)
	activate_tween.tween_property(self, "offset_transform_position", target_offset, duration)
	room.atheneum.active_tweens.append(activate_tween)
	activate_tween.tween_callback(room.atheneum.on_tween_finished.bind(activate_tween))
	
	await activate_tween.finished
	room.atheneum.active_card = self
	room.atheneum.active_room = ere_room
	
	if room.atheneum.active_tweens.is_empty():
		room.atheneum.finish_activate(self, ere_room)

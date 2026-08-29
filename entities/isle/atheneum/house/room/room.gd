class_name Room 
extends PanelContainer


var card_scene = preload("uid://cfe1p2qnaebxk")

var data: RoomData:
	set(value_):
		data = value_

@export var house: House

var cards: Array[Card]

var stamp_to_card: Dictionary
var current_card: Card

var shift_tween: Tween
var sort_tween: Tween


#region init
func init_cards() -> void:
	cards.clear()
	stamp_to_card.clear()
	Helper.clear_children(%Cards)
	
	if not data.stamps.is_empty():
		for stamp_data in data.stamps:
			add_card(stamp_data)
		
		sort_cards(false)
	
	if data.type == Bozo.Room.PARLOR:
		var offset = get_parent().get("theme_override_constants/separation")
		%Cards.offset_transform_position.y = -(Catalog.STAMP_SIZE.y - Catalog.SHADOW_SIZE.y) / 2 + offset

func add_card(stamp_data_: StampData) -> void:
	var card = card_scene.instantiate()
	%Cards.add_child(card)
	stamp_to_card[stamp_data_] = card
	card.room = self
	card.stamp.data = stamp_data_
	card.shadow.data = stamp_data_.shadow
	cards.append(card)
	
	if data.type == Bozo.Room.PARLOR:
		card.skip_on_shadow()

func remove_card() -> void:
	if %Cards.get_child_count() == 0: return
	%Cards.get_children().back().destroy()
	var card = cards.pop_back()
	stamp_to_card.erase(card.stamp)

func disappear_card(stamp_data_: StampData) -> void:
	var card = stamp_to_card[stamp_data_]
	card.disappear()
#endregion

#region sort
func shift_card(card_: Card, shift_: int) -> void:
	var new_index = card_.get_index() + shift_
	if new_index < 0 or new_index >= %Cards.get_child_count(): return
	if shift_tween and shift_tween.is_running(): return
	
	shift_tween = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CIRC).set_parallel(true)
	var duration = Gear.jalousies[Gear.tempo]
	
	var l = get_card_shift_length(card_)
	card_.z_index = 1
	
	shift_tween.tween_property(card_, "offset_transform_position:x", l * shift_, duration)
	
	for _i in abs(shift_):
		var neighbour_index = card_.get_index() + (_i + 1) * sign(shift_)
		var neighbour_card = %Cards.get_child(neighbour_index)
		shift_tween.tween_property(neighbour_card, "offset_transform_position:x", -l * sign(shift_), duration)
	
	await shift_tween.finished
	
	for _i in abs(shift_):
		var neighbour_index = card_.get_index() + (_i + 1) * sign(shift_)
		var neighbour_card = %Cards.get_child(neighbour_index)
		neighbour_card.offset_transform_position.x = 0
	
	card_.offset_transform_position.x = 0
	card_.z_index = 0
	%Cards.move_child(card_, new_index)
	cards.erase(card_)
	cards.insert(new_index, card_)
	
	update_stamps()
	data.house.atheneum.faction.odeum.recalc_scenario(data.type)

func update_stamps() -> void:
	var stamp_datas = []
	
	for card in cards:
		stamp_datas.append(card.stamp.data)
	
	data.stamps.sort_custom(func (a, b): return stamp_datas.find(a) < stamp_datas.find(b))

func sort_cards(with_animation_: bool = true) -> void:
	if %Cards.get_child_count() == 0: return
	if Arbitrator.current_phase and Arbitrator.current_phase.type != Bozo.Phase.DECISION and Arbitrator.current_phase.type != Bozo.Phase.DRAW: return
	if data.stamps.is_empty(): return
	
	var scenarios = data.house.atheneum.faction.odeum.room_to_scenarios[data.type]
	if scenarios.is_empty(): return
	
	var scenario = scenarios.front()
	var sorted_cards = cards.duplicate()
	if sorted_cards.size() == 1: return
	
	for card in cards:
		card.unhover()
	
	if sort_tween and sort_tween.is_running():
		sort_tween.kill()
	
	sorted_cards.sort_custom(func (a, b): return scenario.chains.find(a.stamp.data) < scenario.chains.find(b.stamp.data))

	if not with_animation_:
		for _i in sorted_cards.size():
			%Cards.move_child(sorted_cards[_i], _i)
	else:
		var duration = Gear.sorts[Gear.tempo]
		sort_tween = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CIRC).set_parallel(true)
		
		for new_index in sorted_cards.size():
			var card = sorted_cards[new_index]
			var old_index = cards.find(card)
			var l = card.min_size_x_default * (new_index - old_index)
			sort_tween.tween_property(card.stamp, "offset_transform_position:x", l, duration)
		
		await sort_tween.finished
		
		for _i in sorted_cards.size():
			var card = sorted_cards[_i]
			%Cards.move_child(card, _i)
			card.stamp.offset_transform_position.x = 0
	
	cards.clear()
	cards.append_array(sorted_cards)
	data.apply_scenario_canto_stakes()

func close_up_cards(card_: Card) -> void:
	if Arbitrator.current_phase and Arbitrator.current_phase.type != Bozo.Phase.DECISION: return
	if shift_tween and shift_tween.is_running(): return
	if %Cards.get_child_count() == 0: return
	jalousie(card_)
	await shift_tween.finished
	card_.visible = false
	
	reset_offsets()
	
	if data.stamps.has(card_.stamp.data):
		data.stamps.erase(card_.stamp.data)
		find_best_scenario()

func slide_away() -> void:
	if shift_tween and shift_tween.is_running(): return
	if %Cards.get_child_count() == 0: return
	shift_tween = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CIRC).set_parallel(true)
	var duration = Gear.jalousies[Gear.tempo]
	
	for card in %Cards.get_children():
		card.offset_transform_position = Vector2.ZERO
		var l = -get_card_shift_length(card) * 0.5
		shift_tween.tween_property(card, "offset_transform_position:x", l, duration)

func jalousie(card_: Card = null, is_inside_: bool = true) -> void:
	if shift_tween and shift_tween.is_running(): return
	if %Cards.get_child_count() <= 1: return
	shift_tween = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CIRC).set_parallel(true)
	var duration = Gear.jalousies[Gear.tempo]
	var close_index = card_.get_index()
	
	for _i in %Cards.get_child_count():
		var neighbour_card = %Cards.get_child(_i)
		
		if neighbour_card != card_:
			var l = get_card_shift_length(neighbour_card) * 0.5
			
			if _i > close_index:
				l *= -1
			
			if not is_inside_:
				l *= -1
			
			shift_tween.tween_property(neighbour_card, "offset_transform_position:x", l, duration)

func get_card_shift_length(card_: Card) -> float:
	return card_.size.x + %Cards.get("theme_override_constants/separation")

func reset_offsets() -> void:
	for card in %Cards.get_children():
		card.offset_transform_position = Vector2.ZERO
#endregion

func get_card_target(card_: Card) -> Vector2:
	var placeholder = Control.new()
	placeholder.custom_minimum_size = card_.custom_minimum_size
	placeholder.size = card_.size
	placeholder.size_flags_horizontal = card_.size_flags_horizontal
	placeholder.size_flags_vertical = card_.size_flags_vertical
	placeholder.size_flags_stretch_ratio = card_.size_flags_stretch_ratio
	%Cards.add_child(placeholder)
	
	await get_tree().process_frame
	var target = placeholder.global_position
	%Cards.remove_child(placeholder)
	placeholder.free()
	return target

func plus_card(card_: Card) -> void:
	var card_parent = card_.get_parent()
	card_parent.remove_child(card_)
	card_.room.stamp_to_card.erase(card_.stamp.data)
	card_.room.cards.erase(card_)
	card_.room.data.stamps.erase(card_.stamp.data)
	card_.room.find_best_scenario()
	
	%Cards.add_child(card_)
	stamp_to_card[card_.stamp.data] = card_
	cards.append(card_)
	card_.room = self
	data.stamps.append(card_.stamp.data)
	find_best_scenario()

func find_best_scenario() -> void:
	data.house.atheneum.faction.odeum.init_scenarios(data.type)
	sort_cards()

func skip_phase() -> void:
	Arbitrator.current_phase.exit_phase()

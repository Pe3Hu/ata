class_name Stamp 
extends PanelContainer


@export var stake_scene = preload("uid://ddqqetmqeecl1")

var data: StampData:
	set(value_):
		data = value_
		
		connect_signals()
		init_stakes()
		update_colors()
		update_marks()
		%Spoil.texture = load("res://entities/dice/images/%d.png" % data.spoil_value)

@export var border: Panel

@export var card: Card:
	set(value_):
		card = value_


#region init
func connect_signals() -> void:
	data.is_locked_changed.connect(_on_locked_changed)
	_on_locked_changed()

func _on_locked_changed() -> void:
	if data.is_locked:
		card.custom_minimum_size.x = card.min_size_x_hover
		border.self_modulate.a = 1.0
		offset_transform_position.x = (card.min_size_x_hover - card.min_size_x_default) / 2
	else:
		card.custom_minimum_size.x = card.min_size_x_default
		border.self_modulate.a = 0.0
		offset_transform_position.x = 0

func init_stakes() -> void:
	for type in Catalog.stakes:
		var stake_datas = data.type_to_stakes[type]
		
		match type:
			Bozo.Stake.LEFT:
				stake_datas.sort_custom(func (a, b): return a.joints.front() < b.joints.front())
			Bozo.Stake.LEFT:
				stake_datas.sort_custom(func (a, b): return a.value < b.value)
		
		for stake_data in stake_datas:
			add_stake(stake_data)

func add_stake(stake_data_: StakeData) -> void:
	var stake = stake_scene.instantiate()
	var stakes = get_stakes(stake_data_.type)
	stakes.add_child(stake)
	stake.data = stake_data_

func get_stakes(type_: Bozo.Stake) -> VBoxContainer:
	var path = Bozo.enum_to_string(Bozo.Type.STAKE, type_)
	path = "%" + path.capitalize() + "Stakes"
	return get_node(path)

func update_colors() -> void:
	var color = Digest.matter_to_color[data.origin.matter]
	border.get_theme_stylebox("panel").border_color = color
	%Top.get_theme_stylebox("panel").bg_color = color
	%Bottom.get_theme_stylebox("panel").bg_color = color

func update_marks() -> void:
	%CardMarkLetter.text = data.origin.mark_letter
	%CardMarkDigits.text = data.mark_digits
#endregion

func process_click() -> void:
	if Arbitrator.current_phase.type != Bozo.Phase.DECISION: return
	if data.is_locked: return
	data.origin.atheneum.faction.odeum.current_canto = null
	var local_mouse_pos = get_local_mouse_position()
	
	var part_height = size.y / 5
	
	if local_mouse_pos.y < part_height:
		card.activate()
		return
	
	if local_mouse_pos.y > size.y - part_height:
		card.activate(false)
		return
	
	var half_width = size.x / 2
	var shift_value = 0
	
	if local_mouse_pos.x < half_width:
		shift_value = -1
	else:
		shift_value = 1
	
	shift_value = calc_shift_value(shift_value)
	
	if shift_value != 0:
		var move_card = ActionMoveCard.new(data, shift_value, card.room)
		Arbitrator.current_phase.try_execute_action(move_card)

func calc_shift_value(shift_value_: int) -> int:
	var not_locked_index = card.room.cards.find(card)
	var shift_card = card
	var k: int = -1
	
	if not_locked_index == 0 and shift_value_ < 0: return 0
	if card.room.cards.size() - 1 == 0 and shift_value_ > 0: return 0
	
	while shift_card == card or shift_card.stamp.data.is_locked:
		k += 1
		not_locked_index += shift_value_
		
		if not_locked_index < 0 or not_locked_index >= card.room.cards.size():
			return shift_value_ * max(1, k)
		
		shift_card = card.room.cards[not_locked_index]
		
		if not shift_card.stamp.data.is_locked:
			return shift_value_ * max(1, k)
	
	return shift_value_

func _on_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		process_click()

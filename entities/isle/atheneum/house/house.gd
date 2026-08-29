class_name House
extends PanelContainer


var data: HouseData:
	set(value_):
		data = value_
		
		connect_datas()
		connect_signals()

@export var isle: Isle

@export var parlor: Room
@export var kitchen: Room
@export var bedroom: Room

var room_to_fol: Dictionary
var room_to_ere: Dictionary

var active_tweens: Array[Tween]
var deactivate_cards: Array[Card]


func connect_datas() -> void:
	parlor.data = data.parlor
	kitchen.data = data.kitchen
	bedroom.data = data.bedroom
	
	room_to_fol[bedroom] = kitchen
	room_to_fol[parlor] = bedroom
	
	room_to_ere[kitchen] = bedroom
	#room_to_ere[bedroom] = parlor

func connect_signals() -> void:
	data.draw_phase.connect(_on_draw_phase)
	data.discard_phase.connect(_on_discard_phase)
	#data.punishment_phase.connect(_on_punishment_phase)

func _on_draw_phase() -> void:
	bedroom.init_cards()
	parlor.init_cards()
	
	await get_tree().create_timer(0.5).timeout
	var card = bedroom.cards.front()
	card.activate()
	
	await get_tree().create_timer(0.5).timeout
	card = bedroom.cards.front()
	card.activate()
	
	await get_tree().create_timer(0.5).timeout
	#for _card in kitchen.cards:
	#	_card.stamp.data.is_locked = true
	card.stamp.data.is_locked = true
	
	Arbitrator.apply_pass()

func _on_discard_phase() -> void:
	deactivate_cards.clear()
	
	for _i in range(kitchen.cards.size()-1, -1, -1):
		var card = kitchen.cards[_i]
		
		if card.stamp.data.is_locked:
			card.last_disappear()
		else:
			deactivate_cards.append(card)
	
	if not deactivate_cards.is_empty():
		var duration = Gear.activates[Gear.tempo] * 1.1
		%DiscardTimer.wait_time = duration
		%DiscardTimer.start()

#func _on_punishment_phase() -> void:
	#for card in cards:
		#card.last_disappear()

func on_tween_finished(tween_: Tween) -> void:
	if active_tweens.has(tween_):
		active_tweens.erase(tween_)

func switch_parlor_face() -> void:
	var card = parlor.cards[0]
	card.switch_face()

func _input(event) -> void:
	if event is InputEventKey and event.pressed and not event.echo:
		match event.keycode:
			KEY_SPACE:
				switch_parlor_face()


func _on_discard_timer_timeout() -> void:
	var card = deactivate_cards.pop_back()
	card.activate(false)
	
	if not deactivate_cards.is_empty():
		%DiscardTimer.start()

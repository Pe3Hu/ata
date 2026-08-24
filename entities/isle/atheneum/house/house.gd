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
	_on_draw_phase()
	#data.discard_phase.connect(_on_discard_phase)
	#_on_discard_phase()

func _on_draw_phase() -> void:
	bedroom.init_cards()
	parlor.init_cards()

#func _on_discard_phase() -> void:
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

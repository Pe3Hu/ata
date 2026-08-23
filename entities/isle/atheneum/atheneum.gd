class_name Atheneum 
extends PanelContainer


var data: AtheneumData:
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

var active_card: Card
var active_room: Room


func connect_datas() -> void:
	parlor.data = data.house.parlor
	kitchen.data = data.house.kitchen
	bedroom.data = data.house.bedroom
	
	room_to_fol[bedroom] = kitchen
	room_to_ere[kitchen] = bedroom

func connect_signals() -> void:
	data.draw_phase.connect(_on_draw_phase)
	_on_draw_phase()
	#data.discard_phase.connect(_on_discard_phase)
	#_on_discard_phase()

func _on_draw_phase() -> void:
	bedroom.init_cards()
	kitchen.init_cards()


#func _on_discard_phase() -> void:
	#for card in cards:
		#card.last_disappear()

func on_tween_finished(tween_: Tween) -> void:
	if active_tweens.has(tween_):
		active_tweens.erase(tween_)
	
	#if active_tweens.is_empty():
	#	finish_activate(active_card, active_room)

func finish_activate(card_: Card = null, next_room_: Room = null) -> void:
	if card_ == null or next_room_ == null: return
	var previous_room = card_.room
	next_room_.plus_card(card_)
	previous_room.reset_offsets()
	next_room_.reset_offsets()

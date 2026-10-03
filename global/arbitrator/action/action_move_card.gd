class_name ActionMoveCard
extends ActionData


var room: Room
var shift: int


func _init(echo_: EchoData, shift_: int, room_: Room = null) -> void:
	type = Bozo.Action.MOVE_CARD
	echo = echo_
	shift = shift_
	room = room_

func execute() -> void:
	super.execute()
	animation_left -= 1
	
	if room:
		var card = room.echo_to_card[echo]
		room.shift_card(card, shift)
	else:
		var room_data = echo.room
		var new_index = room_data.echos.find(echo) + shift
		if new_index < 0 or new_index >= room_data.echos.size(): return
		room_data.echos.erase(echo)
		room_data.echos(new_index, echo)
		echo.origin.atheneum.recalc_scenario()

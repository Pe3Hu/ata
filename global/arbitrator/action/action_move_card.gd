class_name ActionMoveCard
extends ActionData


var room: Room
var shift: int


func _init(stamp_: StampData, shift_: int, room_: Room = null) -> void:
	type = Bozo.Action.MOVE_CARD
	stamp = stamp_
	shift = shift_
	room = room_

func execute() -> void:
	if room:
		var card = room.stamp_to_card[stamp]
		room.shift_card(card, shift)
	else:
		var room_data = stamp.room
		var new_index = room_data.stamps.find(stamp) + shift
		if new_index < 0 or new_index >= room_data.stamps.size(): return
		room_data.stamps.erase(stamp)
		room_data.stamps(new_index, stamp)
		stamp.origin.atheneum.recalc_scenario()

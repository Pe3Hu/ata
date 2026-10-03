class_name HouseData
extends RefCounted


@warning_ignore("unused_signal")
signal draw_phase
@warning_ignore("unused_signal")
signal punishment_phase
@warning_ignore("unused_signal")
signal discard_phase

@warning_ignore("unused_signal")
signal advisor_card_activation

var attic: RoomData = RoomData.new(self, Bozo.Room.ATTIC)
var bedroom: RoomData = RoomData.new(self, Bozo.Room.BEDROOM)
var kitchen: RoomData = RoomData.new(self, Bozo.Room.KITCHEN)
var parlor: RoomData = RoomData.new(self, Bozo.Room.PARLOR)
var cellar: RoomData = RoomData.new(self, Bozo.Room.CELLAR)

var rooms: Array[RoomData]
var type_to_room: Dictionary


#region init
func _init() -> void:
	update_room_fol()
	update_room_ere()
	
	rooms = [
		attic,
		parlor,
		bedroom,
		kitchen,
		cellar,
	]
	
	type_to_room[Bozo.Room.ATTIC] = attic
	type_to_room[Bozo.Room.PARLOR] = parlor
	type_to_room[Bozo.Room.BEDROOM] = bedroom
	type_to_room[Bozo.Room.KITCHEN] = kitchen
	type_to_room[Bozo.Room.CELLAR] = cellar

func update_room_fol() -> void:
	attic.fol = parlor
	parlor.fol = bedroom
	bedroom.fol = kitchen
	kitchen.fol = cellar
	cellar.fol = attic

func update_room_ere() -> void:
	attic.ere = cellar
	parlor.ere = attic
	bedroom.ere = parlor
	kitchen.ere = bedroom
	cellar.ere = kitchen

func reset() -> void:
	for room in rooms:
		room.echos.clear()
#endregion

#region refill
func refill_parlor() -> void:
	if attic.echos.is_empty():
		attic.ere.clear()
		attic.echos.shuffle()
	
	var n = min(get_remaining_amount(), Catalog.GYRE_PARLOR_STAMP_SIZE)
	
	while parlor.echos.size() < n:
		attic.transfer_echo()

func direct_refill_bedroom() -> void:
	if attic.echos.is_empty():
		attic.ere.clear()
		attic.echos.shuffle()
	
	var n = min(get_remaining_amount(), Catalog.GYRE_BEDROOM_STAMP_SIZE)
	
	while parlor.echos.size() < n:
		attic.transfer_echo()
	
	while bedroom.echos.size() < n:
		parlor.transfer_echo()

func get_remaining_amount() -> int:
	return attic.echos.size() + cellar.echos.size() + parlor.echos.size()
#endregion

func _on_punishment_phase_end() -> void:
	parlor.cards_reseted.emit()
	kitchen.cards_reseted.emit()
	bedroom.cards_reseted.emit()
	Mother.odeum.locked_echos.clear()

class_name HouseData
extends RefCounted


var atheneum: AtheneumData

var attic: RoomData = RoomData.new(self, Bozo.Room.ATTIC)
var bedroom: RoomData = RoomData.new(self, Bozo.Room.BEDROOM)
var kitchen: RoomData = RoomData.new(self, Bozo.Room.KITCHEN)
var parlor: RoomData = RoomData.new(self, Bozo.Room.PARLOR)
var cellar: RoomData = RoomData.new(self, Bozo.Room.CELLAR)
var rooms: Array[RoomData]


#region init
func _init(atheneum_: AtheneumData) -> void:
	atheneum = atheneum_
	update_room_fol()
	update_room_ere()
	
	rooms = [
		attic,
		parlor,
		bedroom,
		cellar,
	]

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
		room.stamps.clear()
#endregion

#region refill
func refill_parlor() -> void:
	if attic.stamps.is_empty():
		attic.ere.clear()
		attic.stamps.shuffle()
	
	var n = min(get_remaining_amount(), Catalog.GYRE_PARLOR_STAMP_SIZE)
	
	while parlor.stamps.size() < n:
		attic.transfer_stamp()

func direct_refill_bedroom() -> void:
	if attic.stamps.is_empty():
		attic.ere.clear()
		attic.stamps.shuffle()
	
	var n = min(get_remaining_amount(), Catalog.GYRE_BEDROOM_STAMP_SIZE)
	
	while parlor.stamps.size() < n:
		attic.transfer_stamp()
	
	while bedroom.stamps.size() < n:
		parlor.transfer_stamp()

func get_remaining_amount() -> int:
	return attic.stamps.size() + cellar.stamps.size() + parlor.stamps.size()
#endregion

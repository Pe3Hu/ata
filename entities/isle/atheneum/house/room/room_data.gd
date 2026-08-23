class_name RoomData
extends RefCounted


var house: HouseData
var type: Bozo.Room

var fol: RoomData
var ere: RoomData

var stamps: Array[StampData]


#region init
func _init(house_: HouseData, type_: Bozo.Room) -> void:
	house = house_
	type = type_

func clear() -> void:
	if type == Bozo.Room.ATTIC: return
	stamps.shuffle()
	fol.stamps.append_array(stamps)
	stamps.clear()

func transfer_stamp() -> StampData:
	if stamps.is_empty():
		ere.clear()
	
	var stamp = stamps.pop_back()
	fol.stamps.append(stamp)
	return stamp
#endregion

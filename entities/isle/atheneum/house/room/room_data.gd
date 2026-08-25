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

func reset_canto_stakes() -> void:
	for stamp in stamps:
		for stake in stamp.type_to_stakes[Bozo.Stake.LEFT]:
			stake.canto = null

func apply_scenario_canto_stakes() -> void:
	reset_canto_stakes()
	var scenario = house.atheneum.faction.odeum.get_scenario(type)
	
	if scenario:
		for hymn in scenario.hymns:
			for canto in hymn.cantos:
				canto.type_to_stake[Bozo.Stake.LEFT].canto = canto

class_name RoomData
extends RefCounted


@warning_ignore("unused_signal")
signal cards_reseted

var house: HouseData
var type: Bozo.Room

var fol: RoomData
var ere: RoomData

var echos: Array[EchoData]


#region init
func _init(house_: HouseData, type_: Bozo.Room) -> void:
	house = house_
	type = type_

func clear() -> void:
	if type == Bozo.Room.ATTIC: return
	echos.shuffle()
	fol.echos.append_array(echos)
	echos.clear()

func transfer_echo() -> EchoData:
	if echos.is_empty():
		ere.clear()
	
	var echo = echos.pop_back()
	fol.echos.append(echo)
	if fol.type == Bozo.Room.PARLOR or fol.type == Bozo.Room.CELLAR:
		echo.reset()
	return echo
#endregion

func reset_canto_stakes() -> void:
	for echo in echos:
		for stake in echo.type_to_stakes[Bozo.Stake.LEFT]:
			stake.canto = null

func apply_scenario_canto_stakes() -> void:
	reset_canto_stakes()
	var scenario = Mother.odeum.get_scenario(type)
	
	if scenario:
		for hymn in scenario.hymns:
			for canto in hymn.cantos:
				canto.type_to_stake[Bozo.Stake.LEFT].canto = canto

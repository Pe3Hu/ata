class_name ChroniclerData
extends RefCounted


var faction: FactionData
var house: HouseData


func _init(faction_: FactionData) -> void:
	faction = faction_
	house = faction.atheneum.house

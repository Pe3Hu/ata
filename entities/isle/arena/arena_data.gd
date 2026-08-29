class_name ArenaData
extends RefCounted


var isle: IsleData

var arsenal: ArsenalData
var horde: HordeData



func _init(isle_: IsleData) -> void:
	isle = isle_
	
	arsenal = ArsenalData.new(self)
	horde = HordeData.new(self)

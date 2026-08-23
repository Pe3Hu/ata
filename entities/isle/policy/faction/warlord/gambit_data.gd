class_name GambitData
extends RefCounted


var warlord: WarlordData

var raids: Array[RaidData]

var total_overrun: int
var total_profit: int


#region init
func _init(warlord_: WarlordData) -> void:
	warlord = warlord_
	
#endregion

func launch() -> void:
	for raid in raids:
		raid.launch()
	
	warlord.faction.policy.isle.terrain.externals_changed.emit()

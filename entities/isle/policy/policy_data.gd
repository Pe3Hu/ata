class_name PolicyData
extends RefCounted


var isle: IsleData

var factions: Array[FactionData]

var player_faction: FactionData
var current_faction: FactionData


#region init
func _init(isle_: IsleData) -> void:
	isle = isle_
	
	init_factions()

func init_factions() -> void:
	factions.clear()
	var _faction = FactionData.new(self, true)
	
	player_faction = factions[0]
	Arbitrator.player_chronicler = player_faction.chronicler
	current_faction = player_faction
	
	for faction in factions:
		if faction.is_active:
			Arbitrator.factions.append(faction)
#endregion

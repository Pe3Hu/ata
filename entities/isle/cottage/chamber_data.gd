class_name ChamberData
extends RefCounted


var cottage: CottageData
var type: Bozo.Room

var fol: ChamberData
var ere: ChamberData

var ideas: Array[IdeaData]


#region init
func _init(cottage_: CottageData, type_: Bozo.Room) -> void:
	cottage = cottage_
	type = type_

func clear() -> void:
	if type == Bozo.Room.ATTIC: return
	ideas.shuffle()
	fol.ideas.append_array(ideas)
	ideas.clear()

func transfer_idea() -> IdeaData:
	if ideas.is_empty():
		ere.clear()
	
	var idea = ideas.pop_back()
	fol.ideas.append(idea)
	if fol.type == Bozo.Room.PARLOR or fol.type == Bozo.Room.CELLAR:
		idea.reset()
	return idea
#endregion

func reset_canto_stakes() -> void:
	for idea in ideas:
		for stake in idea.type_to_stakes[Bozo.Stake.LEFT]:
			stake.canto = null

func apply_scenario_canto_stakes() -> void:
	reset_canto_stakes()
	var scenario = Mother.odeum.get_scenario(type)
	
	if scenario:
		for hymn in scenario.hymns:
			for canto in hymn.cantos:
				canto.type_to_stake[Bozo.Stake.LEFT].canto = canto

class_name GangData
extends RefCounted


var mission: MissionData

var ideas: Array[IdeaData]


func _init(mission_: MissionData) -> void:
	mission = mission_
	
	init_ideas()

func init_ideas() -> void:
	var idea = IdeaData.new(1)
	ideas.append(idea)

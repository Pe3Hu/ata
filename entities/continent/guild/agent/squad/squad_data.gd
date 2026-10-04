class_name SquadData
extends RefCounted


var agent: AgentData
var members: Array[MemberData]


func _init(agent_: AgentData) -> void:
	agent = agent_
	
	init_members()

func init_members() -> void:
	MemberData.new(self)

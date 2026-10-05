class_name SquadData
extends RefCounted


var agent: AgentData
var members: Array[MemberData]


func _init(agent_: AgentData) -> void:
	agent = agent_
	
	init_members()

func init_members() -> void:
	var size := 1
	if agent.task != null and agent.task.master != null:
		size = Digest.master_to_squad_size.get(agent.task.master.type, 1)
	for _i in size:
		MemberData.new(self)

class_name OverseerData
extends RefCounted


var active_agents: Array[AgentData] = []


func add_agent(agent_: AgentData) -> void:
	if agent_ == null or active_agents.has(agent_): return
	active_agents.append(agent_)

	if not Mother.clock.hour_passed.is_connected(agent_.roll_progress):
		Mother.clock.hour_passed.connect(agent_.roll_progress)

func remove_agent(agent_: AgentData) -> void:
	var idx := active_agents.find(agent_)
	if idx == -1: return
	active_agents.remove_at(idx)

	if Mother.clock.hour_passed.is_connected(agent_.roll_progress):
		Mother.clock.hour_passed.disconnect(agent_.roll_progress)

func getactive_agents() -> Array[AgentData]:
	return active_agents.duplicate()

func clear() -> void:
	for agent in active_agents:
		if Mother.clock.hour_passed.is_connected(agent.roll_progress):
			Mother.clock.hour_passed.disconnect(agent.roll_progress)
	
	active_agents.clear()

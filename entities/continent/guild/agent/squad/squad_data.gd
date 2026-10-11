class_name SquadData
extends RefCounted


signal members_reordered

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

func get_reserved_sums(member_: MemberData) -> Array:
	var reserved_sums = []
	
	for member in members:
		if member == member_:continue
		var soul: SoulData = member.preview_soul
		if soul == null:continue
		for tune in Catalog.UNIQUE_TUNES:
			var dice_str = Bozo.enum_to_string(Bozo.Type.TUNE, tune)
			var dice_sum = soul.get(dice_str).get_sum()
			
			if not reserved_sums.has(dice_sum):
				reserved_sums.append(dice_sum)
	
	return reserved_sums

func reoder_members(shift_: int) -> void:
	var reordered_member = members.duplicate()
	
	match shift_:
		-1:
			var member = reordered_member.pop_front()
			reordered_member.push_back(member)
		1:
			var member = reordered_member.pop_back()
			reordered_member.push_front(member)
	
	members.clear()
	members = reordered_member
	members_reordered.emit()

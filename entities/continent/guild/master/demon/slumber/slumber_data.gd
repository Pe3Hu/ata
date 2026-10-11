class_name SlumberData
extends TaskData


var rift: RiftData
var reinforcement_echos: Array[EchoData]


func _init(master_: MasterData, order_: int) -> void:
	super._init(master_, order_)
	rift = master_.guild.structure

func prepare_nightmare() -> void:
	Mother.nightmare.slumber = self
	update_attic()

func update_attic() -> void:
	var reinforcement_soul = agent.squad.members.back().virtual_soul
	reinforcement_echos.append_array(reinforcement_soul.echos)
	reinforcement_echos.shuffle()
	var echos: Array[EchoData]
	
	for member in agent.squad.members:
		if member.virtual_soul and member.virtual_soul != reinforcement_soul:
			echos.append_array(member.virtual_soul.echos)
	
	if echos.is_empty(): return
	echos.shuffle()
	Mother.house.attic.echos = echos

func get_reinforcements() -> Array[EchoData]:
	var echos: Array[EchoData]
	var n = min(reinforcement_echos.size(), Catalog.REINFORCEMENT_ECHOS_LIMIT)
	
	for _i in n:
		var echo = reinforcement_echos.pop_back()
		echos.append(echo)
	
	return echos

func test_update_attic() -> void:
	var reinforcement_soul = Mother.guild.souls.back()
	reinforcement_echos.append_array(reinforcement_soul.echos)
	reinforcement_echos.shuffle()
	var echos: Array[EchoData]
	
	for _i in 2:
		var soul = Mother.guild.souls[_i]
		echos.append_array(soul.echos)
	
	if echos.is_empty(): return
	echos.shuffle()
	Mother.house.attic.echos = echos

class_name NightmareData
extends RefCounted


var slumber: SlumberData


func update_attic() -> void:
	var echos: Array[EchoData]
	
	for member in slumber.agent.squad.members:
		if member.virtual_soul:
			echos.append_array(member.virtual_soul.echos)
	
	if echos.is_empty(): return
	echos.shuffle()
	Mother.house.attic.echos = echos

func test_update_attic() -> void:
	var echos: Array[EchoData]
	
	for _i in 3:
		var soul = Mother.guild.souls[_i]
		echos.append_array(soul.echos)
	
	if echos.is_empty(): return
	echos.shuffle()
	Mother.house.attic.echos = echos

class_name TaskData
extends RefCounted


var master: MasterData
var agent: AgentData
var tribute: TributeData

var rank: int


func _init(master_: MasterData, rank_: int) -> void:
	master = master_
	rank = rank_
	
	agent = AgentData.new(self)
	master.tasks.append(self)
	
	init_tribute()

func init_tribute() -> void:
	var price = Digest.master_to_price[master.type] * (rank + 1)
	var volumes = Digest.master_to_volumes[master.type]
	tribute = TributeData.new(price, volumes)

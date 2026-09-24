class_name CaveData
extends RefCounted


var miner: MinerData
var rank: int

var lode: LodeData
var tribute: TributeData


func _init(miner_: MinerData, rank_: int) -> void:
	miner = miner_
	rank = rank_
	
	miner.caves.append(self)
	
	lode = LodeData.new(self)
	init_tribute()

func init_tribute() -> void:
	var price = Digest.master_to_price[miner.type] * rank
	var volumes = Digest.master_to_volumes[miner.type]
	tribute = TributeData.new(price, volumes)

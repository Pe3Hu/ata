class_name FireworkData
extends RefCounted


var lightkeeper: LightkeeperData
var rank: int

var tribute: TributeData


func _init(lightkeeper_: LightkeeperData, rank_: int) -> void:
	lightkeeper = lightkeeper_
	rank = rank_
	
	lightkeeper.fireworks.append(self)
	
	init_tribute()

func init_tribute() -> void:
	var price = Digest.master_to_price[lightkeeper.type] * rank
	var volumes = Digest.master_to_volumes[lightkeeper.type]
	tribute = TributeData.new(price, volumes)

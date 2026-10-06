class_name LootData
extends RefCounted


var depredation: DepredationData
var shards: Array[ShardData]
var matter_to_shard: Dictionary


func _init(depredation_: DepredationData) -> void:
	depredation = depredation_
	
	init_shards()

func init_shards() -> void:
	for matter in Catalog.matters:
		#var amount = 10
		var volume = 30
		var _shard = ShardData.new(matter, volume)
		shards.append(_shard)
		matter_to_shard[matter] = _shard

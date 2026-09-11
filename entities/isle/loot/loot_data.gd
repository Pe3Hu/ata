class_name LootData
extends RefCounted


var mission: MissionData
var shards: Array[ShardData]
var matter_to_shard: Dictionary


func _init(mission_: MissionData) -> void:
	mission = mission_
	
	init_shards()

func init_shards() -> void:
	for matter in Catalog.matters:
		var amount = 10
		var _shard = ShardData.new(self, matter, amount)

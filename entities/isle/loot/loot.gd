class_name Loot
extends PanelContainer


var shard_scene = preload('uid://ksgxcdi6f6kj')

var data: LootData:
	set(value_):
		data = value_
		
		init_shards()


func init_shards() -> void:
	for shard_data in data.shards:
		add_shard(shard_data)

func add_shard(shard_data_: ShardData) -> void:
	var shard = shard_scene.instantiate()
	%Shards.add_child(shard)
	shard.data = shard_data_

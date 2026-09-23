class_name ShardData
extends RefCounted


var matter: Bozo.Matter
var volume: int


func _init(matter_: Bozo.Matter, volume_: int) -> void:
	matter = matter_
	volume = volume_
	
	#loot.shards.append(self)
	#loot.matter_to_shard[matter] = self

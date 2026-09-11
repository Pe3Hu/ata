class_name ShardData
extends RefCounted


var loot: LootData
var matter: Bozo.Matter
var amount: int


func _init(loot_: LootData, matter_: Bozo.Matter, amount_: int) -> void:
	loot = loot_
	matter = matter_
	amount = amount_
	
	loot.shards.append(self)
	loot.matter_to_shard[matter] = self

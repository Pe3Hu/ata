class_name QuotumData
extends RefCounted


var shard: ShardData
var amount: int


func _init(matter_: Bozo.Matter, volume_: int, amount_: int) -> void:
	shard = ShardData.new(matter_, volume_)
	amount = amount_

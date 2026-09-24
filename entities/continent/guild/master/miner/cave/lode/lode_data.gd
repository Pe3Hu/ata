class_name LodeData
extends RefCounted


var cave: CaveData
var veins: Array[VeinData]
var matter: Bozo.Matter


func _init(cave_: CaveData) -> void:
	cave = cave_
	matter = cave.miner.guild.structure.matters.front()
	
	init_veins()

func init_veins() -> void:
	for volume in Digest.matter_to_rank_to_volume_to_percent[matter][cave.rank]:
		var percent = Digest.matter_to_rank_to_volume_to_percent[matter][cave.rank][volume]
		var _vein = VeinData.new(self, volume, percent)

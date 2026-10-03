class_name LodeData
extends RefCounted


var cave: CaveData
var veins: Array[VeinData]
var matter: Bozo.Matter

var volume_to_weight: Dictionary

var spoils: Array[SpoilData]
var volume_to_spoil: Dictionary


func _init(cave_: CaveData) -> void:
	cave = cave_
	matter = cave.master.guild.structure.matters.front()
	
	init_veins()

func init_veins() -> void:
	volume_to_weight.clear()
	
	for volume in Digest.matter_to_order_to_volume_to_percent[matter][cave.order]:
		var percent = Digest.matter_to_order_to_volume_to_percent[matter][cave.order][volume]
		VeinData.new(self, volume, percent)
		volume_to_weight[volume] = int(percent / 5)

func reset_spoils() -> void:
	spoils.clear()
	volume_to_spoil.clear()
	
	for vein in veins:
		var spoil = SpoilData.new(matter, vein.volume)
		spoils.append(spoil)
		volume_to_spoil[vein.volume] = spoil

func fill_spoils() -> void:
	reset_spoils()
	var total_spoil_amount: int = Digest.master_to_price[cave.master.type] * (cave.order + 1) * Catalog.MINER_SPOIL_FACTOR
	var volume_to_index: Dictionary
	
	for _i in veins.size():
		volume_to_index[veins[_i].volume] = _i
	
	while total_spoil_amount > 0:
		var volume = Helper.get_random_key(volume_to_weight)
		var index = volume_to_index[volume]
		var amount = Helper.rng.randi_range(1, Catalog.miner_max_spoil_amount[index])
		
		if amount * volume > total_spoil_amount:
			amount = max(floor(float(total_spoil_amount) / volume), 0)
		
		var spoil = volume_to_spoil[volume]
		spoil.amount += amount
		total_spoil_amount -= amount * volume
	
	#var compensation = min(floor(float(abs(total_spoil_amount)) / veins.front().volume), spoils.front().amount)
	#spoils.front().amount -= compensation
	#total_spoil_amount += compensation * veins.front().volume
	#print(total_spoil_amount)
	#
	#for spoil in spoils:
		#print([spoil.shard.volume, spoil.amount])

class_name PieData
extends RefCounted


var kernel: KernelData

var slices: Array[SliceData]
var volume_to_matter_to_slice: Dictionary
var matter_to_volume_to_slice: Dictionary


func _init(kernel_: KernelData) -> void:
	kernel = kernel_
	
	init_slices()
	init_start_amounts()

func init_slices() -> void:
	for _i in Catalog.slice_volumes.size():
		var _slice = SliceData.new(self)

func init_start_amounts() -> void:
	var amount_left = int(Catalog.STARTER_HARVEST_AMOUNT)
	var biomes = Catalog.biomes.duplicate()
	biomes.shuffle()
	biomes.pop_back()
	
	while amount_left > 0:
		for biome in biomes:
			if amount_left <= 0: break
			var amount = Helper.rng.randi_range(1, min(3, amount_left))#amount_left * 0.33)
			var source = kernel.faction.policy.isle.forge.biome_to_source[biome]
			var volume = source.get_rnd_volume()
			var slice = matter_to_volume_to_slice[source.matter][volume]
			slice.amount += amount
			slice.next_amount += amount
			amount_left -= amount
	print(amount_left)
	fill_prime_matters()

func fill_prime_matters() -> void:
	var prime_matters = []
	
	for matter in Catalog.matters:
		var volume = Digest.matter_to_factor[matter]
		
		if get_total_volume_amount(volume) == 0:
			prime_matters.append(matter)
	
	if prime_matters.is_empty():
		prime_matters.append_array(Catalog.matters)
	
	@warning_ignore("integer_division")
	var prime_amount: int = Catalog.STARTER_PRIME_AMOUNT / prime_matters.size()
	
	for matter in prime_matters:
		var volume = Digest.matter_to_factor[matter]
		var slice = volume_to_matter_to_slice[volume][matter]
		slice.amount += prime_amount
		slice.next_amount += prime_amount

func get_total_volume_amount(volume_: int) -> int:
	var amount: int = 0
	
	for matter in volume_to_matter_to_slice[volume_]:
		var slice = volume_to_matter_to_slice[volume_][matter]
		amount += slice.amount
	
	return amount

func apply_raid_amounts() -> void:
	for slice in slices:
		slice.apply_raid_amounts()

func wither() -> void:
	for slice in slices:
		slice.wither()

func is_available(volume_: int, amount_: int = 1, matter_: Bozo.Matter = Bozo.Matter.ANY) -> bool:
	if not volume_to_matter_to_slice.has(volume_): return false
	var available_amount = 0
	
	for matter in volume_to_matter_to_slice[volume_]:
		if matter_ == Bozo.Matter.ANY or matter == matter_:
			var slice = volume_to_matter_to_slice[volume_][matter]
			available_amount += slice.amount
	
	return amount_ <= available_amount

func get_payment_matter(volume_: int, amount_: int = 1) -> Variant:
	if not is_available(volume_, amount_): return null
	var options = []
	
	for matter in volume_to_matter_to_slice[volume_]:
		var slice = volume_to_matter_to_slice[volume_][matter]
		
		if slice.amount >= amount_:
			options.append(matter)
	
	return options.pick_random()

func bite_off(matter_: Bozo.Matter, volume_: int, amount_: int = 1) -> void:
	var slice = matter_to_volume_to_slice[matter_][volume_]
	slice.amount -= amount_

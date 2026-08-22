class_name KernelData
extends RefCounted


@warning_ignore("unused_signal")
signal growth_phase
@warning_ignore("unused_signal")
signal stock_phase

var faction: FactionData

var usurer: UsurerData = UsurerData.new(self)
var pie: PieData


func _init(faction_: FactionData) -> void:
	faction = faction_
	pie = PieData.new(self)

func apply_starter_volumes() -> void:
	pass
	#if not faction.is_active: return
	#
	#for _i in Catalog.STARTER_HARVEST_AMOUNT:
		#grow_harvest(true)
	#
	#var prime_matters = []
	#
	#for matter in Catalog.matters:
		#var volume = Digest.matter_to_factor[matter]
		#
		#if granary.get_total_volume_amount(volume) == 0:
			#prime_matters.append(matter)
	#
	#if prime_matters.is_empty():
		#prime_matters.append_array(Catalog.matters)
	#
	#@warning_ignore("integer_division")
	#var prime_amount: int = Catalog.STARTER_PRIME_AMOUNT / prime_matters.size()
	#
	#for matter in prime_matters:
		#var volume = Digest.matter_to_factor[matter]
		#var granary_straw = granary.volume_to_matter_to_straw[volume][matter]
		#granary_straw.amount += prime_amount
		#granary_straw.next_amount += prime_amount

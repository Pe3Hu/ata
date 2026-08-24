class_name AtheneumData
extends RefCounted


var faction: FactionData

var house: HouseData
var origins: Array[OriginData]

var alphabet: Array
var recruiment_matters: Array[Bozo.Matter]


#region init
func _init(faction_: FactionData) -> void:
	faction = faction_
	
	house = HouseData.new(self)
	init_origins()

func init_origins() -> void:
	origins.clear()
	refill_alphabet()
	var n = 2
	
	for _i in n:
		recruiment_phase()

func refill_alphabet() -> void:
	if not alphabet.is_empty(): return
	var l = floori(float(origins.size()) / 26) + 1
	alphabet = range(26).map(func(a): return char(90 - a).repeat(l))
#endregion

func discard_bedroom(is_phase_: bool = true) -> void:
	var forge_stamps: Array[StampData]
	forge_stamps.append_array(house.bedroom.stamps)
	forge_stamps.append_array(faction.treasury.kernel.fleet.stampss)
	
	faction.isle.forge.stamps.append_array(forge_stamps)
	
	house.bedroom.clear()
	faction.treasury.kernel.fleet.stamps.clear()
	
	if is_phase_:
		house.atheneum.discard_phase.emit()
		faction.treasury.kernel.fleet.discard_phase.emit()

func recruiment_phase(intro_sum_: int = 20, matter_: Variant = null) -> void:
	if matter_ != null:
		recruiment_matters.append(matter_)
	
	if recruiment_matters.is_empty():
		recruiment_matters.append_array(Catalog.matters)
		recruiment_matters.shuffle()
	
	var matter = recruiment_matters.pop_back()
	var intro = Digest.sum_to_matter_to_intro[intro_sum_][matter].pick_random()
	var verse_index = Digest.matter_to_verse[matter].pick_random()
	var verse = load("res://entities/dice/datas/verse/%d.tres" % verse_index)
	var _origin = OriginData.new(self, matter, intro, verse)
	house.attic.stamps.shuffle()

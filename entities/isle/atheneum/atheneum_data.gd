class_name AtheneumData
extends RefCounted


@warning_ignore("unused_signal")
signal draw_phase
@warning_ignore("unused_signal")
signal discard_phase


var faction: FactionData

var house: HouseData
var origins: Array[OriginData]
var scenarios: Array[ScenarioData]

var alphabet: Array
var recruiment_matters: Array[Bozo.Matter]


#region init
func _init(faction_: FactionData) -> void:
	faction = faction_
	
	house = HouseData.new(self)
	init_origins()
	#preparation()
	#init_test()

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

func init_scenarios() -> void:
	init_permutations()
#endregion

func init_permutations() -> void:
	scenarios.clear()
	var stamp_queue = house.bedroom.stamps.duplicate()
	var spoils: Array[StampData]
	
	if not stamp_queue.is_empty():
		var permutations = Helper.generate_permutations(stamp_queue)
		
		for permutation in permutations:
			var _scenario = ScenarioData.new(self, permutation, spoils)
		
		for _i in range(2, stamp_queue.size() - 2, 1):
			var arrangements = Helper.generate_arrangements_fixed_size(stamp_queue, _i)
		
			for arrangement in arrangements:
				spoils = stamp_queue.filter(func (a): return not arrangement.has(a))
				var _scenario = ScenarioData.new(self, arrangement, spoils)
	else:
		for ark in Arbitrator.chronicler.fleet.arks:
			spoils.append(ark.stamp)
		
		var _scenario = ScenarioData.new(self, [], spoils)
	
	scenarios.sort_custom(func (a, b): return a.pulse_weight > b.pulse_weight)
	
	if faction == faction.policy.player_faction:
		var scenario = scenarios.front()
		var pulses = []
		
		for hymn in scenario.hymns:
			pulses.append(hymn.get_canto_with_max_pulse().pulse_value)
		
		print([scenario.pulse_weight, pulses])
		
	faction.odeum.current_scenario = scenarios.front()

func recalc_scenario() -> void:
	var spoils: Array[StampData]
	var permutation = house.bedroom.stamps.duplicate()
	faction.odeum.current_scenario = ScenarioData.new(self, permutation, spoils)

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

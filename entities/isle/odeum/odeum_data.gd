class_name OdeumData
extends RefCounted


signal bedroom_scenario_changed
signal kitchen_scenario_changed

var faction: FactionData
var room_to_scenarios: Dictionary

var bedroom_scenario: ScenarioData:
	set(value_):
		bedroom_scenario = value_
		bedroom_scenario_changed.emit()

var kitchen_scenario: ScenarioData:
	set(value_):
		kitchen_scenario = value_
		kitchen_scenario_changed.emit()


var current_canto: CantoData:
	set(value_):
		if value_ != current_canto:
			if current_canto:
				current_canto.is_selected = false
			
			current_canto = value_
			
			if current_canto:
				current_canto.is_selected = true


func _init(faction_: FactionData) -> void:
	faction = faction_
	
	room_to_scenarios[Bozo.Room.BEDROOM] = []
	room_to_scenarios[Bozo.Room.KITCHEN] = []
	room_to_scenarios[Bozo.Room.PARLOR] = []

func init_scenarios(type_: Bozo.Room = Bozo.Room.BEDROOM) -> void:
	init_permutations(type_)

func init_permutations(type_: Bozo.Room) -> void:
	room_to_scenarios[type_].clear()
	var stamp_queue = faction.atheneum.house.type_to_room[type_].stamps.duplicate()
	var spoils: Array[StampData]
	
	if not stamp_queue.is_empty():
		var permutations = Helper.generate_permutations(stamp_queue)
		
		for permutation in permutations:
			var _scenario = ScenarioData.new(self, permutation, spoils, type_)
		
		for _i in range(2, stamp_queue.size() - 2, 1):
			var arrangements = Helper.generate_arrangements_fixed_size(stamp_queue, _i)
		
			for arrangement in arrangements:
				spoils = stamp_queue.filter(func (a): return not arrangement.has(a))
				var _scenario = ScenarioData.new(self, arrangement, spoils, type_)
	else:
		for ark in Arbitrator.chronicler.fleet.arks:
			spoils.append(ark.stamp)
		
		var _scenario = ScenarioData.new(self, [], spoils, type_)
	
	room_to_scenarios[type_].sort_custom(func (a, b): return a.pulse_weight > b.pulse_weight)
	
	if faction == faction.policy.player_faction:
		var scenario = room_to_scenarios[type_].front()
		var pulses = []
		
		for hymn in scenario.hymns:
			pulses.append(hymn.get_canto_with_max_pulse().pulse_value)
		
		print([scenario.pulse_weight, pulses])
	
	update_scenario(type_, room_to_scenarios[type_].front())

func recalc_scenario(type_: Bozo.Room) -> void:
	var spoils: Array[StampData]
	var permutation = faction.atheneum.house.type_to_room[type_].stamps.duplicate()
	var scenario = ScenarioData.new(self, permutation, spoils, type_)
	update_scenario(type_, scenario)

func update_scenario(type_: Bozo.Room, scenario_: ScenarioData) -> void:
	match type_:
		Bozo.Room.BEDROOM:
			bedroom_scenario = scenario_
		Bozo.Room.KITCHEN:
			kitchen_scenario = scenario_
	
	faction.atheneum.house.type_to_room[type_].apply_scenario_canto_stakes()

func get_scenario(type_: Bozo.Room) -> Variant:
	match type_:
		Bozo.Room.BEDROOM:
			return bedroom_scenario
		Bozo.Room.KITCHEN:
			return kitchen_scenario
	
	return null

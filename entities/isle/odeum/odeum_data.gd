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

var locked_stamps: Array[StampData]


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
	
	if type_ == Bozo.Room.KITCHEN and not locked_stamps.is_empty():
		stamp_queue = stamp_queue.filter(func (a): return not locked_stamps.has(a))
	
	if not stamp_queue.is_empty():
		var permutations = Helper.generate_permutations(stamp_queue)
		
		for permutation in permutations:
			if type_ == Bozo.Room.KITCHEN and not locked_stamps.is_empty():
				var chains = permutation.duplicate()
				chains.append_array(locked_stamps)
				var _scenario = ScenarioData.new(self, chains, type_)
				
				for _i in permutation.size():
					chains = permutation.duplicate()
					
					for _j in range(locked_stamps.size()-1, -1, -1):
						var locked_stamp = locked_stamps[_j]
						chains.insert(_i, locked_stamp)
				
					_scenario = ScenarioData.new(self, chains, type_)
			else:
				var _scenario = ScenarioData.new(self, permutation, type_)
	else:
		return
	
	#if type_ == Bozo.Room.KITCHEN:
	#	print([Bozo.enum_to_string(Bozo.Type.ROOM, type_), room_to_scenarios[type_].size()])
	
	room_to_scenarios[type_].sort_custom(func (a, b): return a.pulse_weight > b.pulse_weight)
	
	if faction == faction.policy.player_faction:
		var scenario = room_to_scenarios[type_].front()
		var pulses = []
		
		for hymn in scenario.hymns:
			pulses.append_array(hymn.get_canto_pulses())
		
		#print([Bozo.enum_to_string(Bozo.Type.ROOM, type_), scenario.pulse_weight, pulses])
	
	update_scenario(type_, room_to_scenarios[type_].front())

func recalc_scenario(type_: Bozo.Room) -> void:
	var permutation = faction.atheneum.house.type_to_room[type_].stamps.duplicate()
	var scenario = ScenarioData.new(self, permutation, type_)
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

func update_locked_stamps() -> void:
	locked_stamps.clear()
	#for stamp in kitchen.stamps:
	#	if stamp.is_locked:
	#		locked_stamps.append(stamp)
	locked_stamps = kitchen_scenario.chains.filter(func (a): return a.is_locked)
	#locked_stamps.sort_custom(func (a, b): return kitchen.stamps.find(a) > kitchen.stamps.find(b))
	print("___")
	for stamp in locked_stamps:
		print(["lock", stamp.get_mark()])

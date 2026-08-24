class_name ScenarioData
extends Resource


var odeum: OdeumData
var chains: Array[StampData]
var spoils: Array[StampData]
var room: Bozo.Room

var active_spoil: StampData

var spoil_weight: int = 0
var pulse_weight: int = 0

var hymns: Array[HymnData]


func _init(odeum_: OdeumData, chains_: Array[StampData], spoils_: Array[StampData], room_: Bozo.Room) -> void:
	odeum = odeum_
	chains.append_array(chains_)
	spoils.append_array(spoils_)
	room = room_
	
	init_hymns()
	calc_spoil_weight()
	calc_pulse_weight()
	odeum.room_to_scenarios[room].append(self)

func init_hymns() -> void:
	hymns.clear()
	
	for _i in chains.size() - 1:
		var first = chains[_i]
		var second = chains[_i + 1]
		var _hymn = HymnData.new(self, [first, second])

func update_critical_cantos() -> void:
	for hymn in hymns:
		for canto in hymn.cantos:
			canto.update_is_critical()

func calc_pulse_weight() -> void:
	pulse_weight = 0
	
	for hymn in hymns:
		pulse_weight += hymn.get_canto_with_max_pulse().pulse_value

func calc_spoil_weight() -> void:
	spoil_weight = 0

class_name CantoData
extends RefCounted


signal is_critical_changed
signal is_selected_changed
signal voice

var hymn: HymnData

var intro: TuneData
var verse: TuneData
var outro: TuneData

var type_to_stake: Dictionary

var joint: int

var pulse_value: int = 0

var is_critical: bool = false:
	set(value_):
		if is_critical != value_:
			is_critical = value_
			is_critical_changed.emit()

var is_selected: bool = false:
	set(value_):
		if is_selected != value_:
			is_selected = value_
			is_selected_changed.emit()


#region init
func _init(hymn_: HymnData, joint_: int, intro_: StampData, verse_: Variant, outro_: Variant) -> void:
	hymn = hymn_
	joint = joint_
	intro = TuneData.new(self, intro_, Bozo.Tune.INTRO)
	var tune_type: Bozo.Tune
	
	if verse_ != null:
		tune_type = Bozo.Tune.VERSE
		verse = TuneData.new(self, verse_, tune_type)
	
	if outro_ != null:
		tune_type = Bozo.Tune.OUTRO
		outro = TuneData.new(self, outro_, tune_type)
	
	update_pulse()
	
	if hymn.cantos.has(self):
		hymn.tune_to_canto[tune_type] = self

func update_pulse() -> void:
	pulse_value = intro.stake.value
	
	if verse:
		if verse.stake.is_voiced: return
		pulse_value += verse.stake.value
	
	if outro:
		if outro.stake.is_voiced: return
		pulse_value *= outro.stake.value
	
	if Catalog.pulses.has(pulse_value) and pulse_value > 0:
		#if is_affordable():
		hymn.cantos.append(self)
	else:
		return
	
	#if hymn.scenario.atheneum.faction.type == Bozo.Faction.BLUE:
		#if verse:
			#print([intro.stake.value, "+", verse.stake.value, "=", pulse_value ])
		#
		#if outro:
			#print([intro.stake.value, "*", outro.stake.value, "=", pulse_value])

func is_affordable() -> bool:
	var pie = hymn.scenario.odeum.faction.kernel.pie
	var demand_volume_to_amount: Dictionary
	
	for type in type_to_stake:
		var volume = type_to_stake[type].value
		
		if not demand_volume_to_amount.has(volume):
			demand_volume_to_amount[volume] = 0
		
		demand_volume_to_amount[volume] += 1
	
	for volume in demand_volume_to_amount:
		var amount = demand_volume_to_amount[volume]
		
		if not pie.is_available(volume, amount):
			return false
	
	return true
#endregion

func apply_voice() -> void:
	type_to_stake[Bozo.Stake.LEFT].is_voiced = true
	var pie = hymn.scenario.odeum.faction.kernel.pie
	var penalty_values = []
	var penalty_matters = []
	
	
	for type in type_to_stake:
		var stake = type_to_stake[type]
		stake.stamp.is_locked = true
		stake.canto = null
		var volume = stake.value
		
		if not pie.is_available(volume):
			var options = Helper.get_matters(volume)
			var matter = options.pick_random()
			penalty_matters.append(matter)
			penalty_values.append(volume)
		else:
			var matter = pie.get_payment_matter(volume)
			pie.bite_off(matter, volume)
	
	if outro:
		penalty_values.append(get_penalty())
		penalty_matters.append(outro.stamp.origin.matter)
	
	if not penalty_matters.is_empty():
		var usurer = pie.kernel.usurer
		
		for _i in penalty_matters.size():
			var matter = penalty_matters[_i]
			var value = penalty_values[_i]
			usurer.borrow(matter, value)
	
	if hymn.scenario.odeum.current_canto:
		hymn.scenario.odeum.current_canto = null
	
	hymn.scenario.odeum.update_locked_stamps()
	hymn.cantos.erase(self)
	voice.emit()

func get_penalty() -> int:
	var penalty: int = 0
	if verse: return penalty
	penalty = pulse_value - outro.stake.value - intro.stake.value
	return penalty

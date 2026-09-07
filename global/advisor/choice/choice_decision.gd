class_name ChoiceDecision
extends Choice


func _init() -> void:
	super._init()
	type = Bozo.Phase.DECISION

func enter_choice():
	super.enter_choice()
	#active_card()

func next_action() -> void:
	if not Arbitrator.faction.atheneum.house.bedroom.stamps.is_empty():
		active_card()
		return
	
	if not Arbitrator.faction.atheneum.house.parlor.stamps.is_empty() and not Arbitrator.faction.odeum.kitchen_scenario.hymns.is_empty():
		voice_canto()
		return
	
	pass

func active_card() -> void:
	Arbitrator.faction.atheneum.house.advisor_card_activation.emit()

func voice_canto() -> void:
	var canto: CantoData = get_perfect_canto()
	var shadow_options: Array[ShadowData]
	
	if canto == null:
		canto = get_overkill_canto()
	
	if canto == null:
		canto = get_max_canto()
	
	if canto == null:
		return
	
	for stamp in Arbitrator.faction.atheneum.house.parlor.stamps:
		if canto.pulse_value >= stamp.shadow.current_shade:
			shadow_options.append(stamp.shadow)
	
	var shadow: ShadowData
	
	if not shadow_options.is_empty():
		shadow_options.sort_custom(func (a, b): return a.current_shade - canto.pulse_value < b.current_shade - canto.pulse_value)
		shadow = shadow_options.pick_random()
	else:
		for stamp in Arbitrator.faction.atheneum.house.parlor.stamps:
			shadow_options.append(stamp.shadow)
		
		shadow_options.sort_custom(func (a, b): return a.current_shade - canto.pulse_value < b.current_shade - canto.pulse_value)
		shadow = shadow_options.front()
	
	if shadow == null:
		pass
	
	Arbitrator.faction.atheneum.faction.odeum.current_canto = canto
	var attack_shadow = ActionAttackShadow.new(shadow, true)
	Arbitrator.current_phase.try_execute_action(attack_shadow)

func get_perfect_canto() -> Variant:
	var perfect_cantos: Array[CantoData]
	
	for hymn in Arbitrator.faction.odeum.kitchen_scenario.hymns:
		for canto in hymn.cantos:
			if canto.is_perfect:
				perfect_cantos.append(canto)
	
	if not perfect_cantos.is_empty():
		perfect_cantos.sort_custom(func (a, b): return a.pulse_value > b.pulse_value)
		return perfect_cantos.front()
	
	return null

func get_overkill_canto() -> Variant:
	var overkill_cantos: Array[CantoData]
	
	for hymn in Arbitrator.faction.odeum.kitchen_scenario.hymns:
		for canto in hymn.cantos:
			for stamp in Arbitrator.faction.atheneum.house.parlor.stamps:
				if canto.pulse_value >= stamp.shadow.current_shade:
					overkill_cantos.append(canto)
					break
	
	if not overkill_cantos.is_empty():
		overkill_cantos.sort_custom(func (a, b): return a.pulse_value > b.pulse_value)
		return overkill_cantos.front()
	
	return null

func get_max_canto() -> Variant:
	var cantos: Array[CantoData]
	
	for hymn in Arbitrator.faction.odeum.kitchen_scenario.hymns:
		for canto in hymn.cantos:
			cantos.append(canto)
	
	if not cantos.is_empty():
		cantos.sort_custom(func (a, b): return a.pulse_value > b.pulse_value)
		return cantos.front()
	
	return null

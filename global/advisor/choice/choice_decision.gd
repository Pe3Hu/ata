class_name ChoiceDecision
extends Choice


func _init() -> void:
	super._init()
	type = Bozo.Phase.DECISION

func enter_choice():
	super.enter_choice()
	if Gear.is_auto_play:
		next_action()

func next_action() -> void:
	var kitchen_scenario = Mother.odeum.kitchen_scenario
	
	if not Mother.house.bedroom.echos.is_empty() and Mother.house.kitchen.echos.size() < Catalog.DEFAULT_KITCHEN_LIMIT:
		active_card()
		return
	
	if not Mother.house.parlor.echos.is_empty() and kitchen_scenario and not kitchen_scenario.hymns.is_empty():
		voice_canto()
		return
	
	Arbitrator.current_phase.exit_phase()

func active_card() -> void:
	Mother.house.advisor_card_activation.emit()

func voice_canto() -> void:
	var canto: CantoData = get_canto(Bozo.Filter.PERFECT)
	var shadow_options: Array[ShadowData]
	
	if canto == null:
		canto = get_canto(Bozo.Filter.OVERKILL)
	
	if canto == null:
		canto = get_canto(Bozo.Filter.MAX)
	
	if canto == null:
		Arbitrator.current_phase.exit_phase()
		return
	
	for echo in Mother.house.parlor.echos:
		if canto.pulse_value >= echo.shadow.shade.current_value:
			shadow_options.append(echo.shadow)
	
	var shadow: ShadowData
	
	if not shadow_options.is_empty():
		shadow_options.sort_custom(func (a, b): return a.shade.current_value < b.shade.current_value)
		shadow = shadow_options.pick_random()
	else:
		for echo in Mother.house.parlor.echos:
			shadow_options.append(echo.shadow)
		
		shadow_options.sort_custom(func (a, b): return a.shade.current_value < b.shade.current_value)
		shadow = shadow_options.front()
	
	if shadow == null:
		pass
	
	Mother.odeum.current_canto = canto
	var attack_shadow = ActionAttackShadow.new(shadow, true)
	Arbitrator.current_phase.try_execute_action(attack_shadow)

func get_canto(filter_: Bozo.Filter) -> Variant:
	var cantos: Array[CantoData] = []
	
	for hymn in Mother.odeum.kitchen_scenario.hymns:
		for canto in hymn.cantos:
			match filter_:
				Bozo.Filter.PERFECT:
					if canto.is_perfect:
						cantos.append(canto)
				Bozo.Filter.OVERKILL:
					for echo in Mother.house.parlor.echos:
						if canto.pulse_value >= echo.shadow.shade.current_value:
							cantos.append(canto)
							break
				Bozo.Filter.MAX:
					cantos.append(canto)
	
	if not cantos.is_empty():
		cantos.sort_custom(func (a, b): return a.pulse_value > b.pulse_value)
		return cantos.front()
	
	return null

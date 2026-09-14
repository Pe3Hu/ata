class_name ChoiceDecision
extends Choice


enum Filter {
	PERFECT,
	OVERKILL,
	MAX,
}


func _init() -> void:
	super._init()
	type = Bozo.Phase.DECISION

func enter_choice():
	super.enter_choice()
	#active_card()

func next_action() -> void:
	if not Arbitrator.faction.atheneum.house.bedroom.stamps.is_empty():
		if not Arbitrator.faction.atheneum.house.kitchen.stamps.size() == Catalog.DEFAULT_KITCHEN_LIMIT:
			active_card()
			return
	
	if not Arbitrator.faction.atheneum.house.parlor.stamps.is_empty() and not Arbitrator.faction.odeum.kitchen_scenario.hymns.is_empty():
		voice_canto()
		return
	
	Arbitrator.current_phase.exit_phase()

func active_card() -> void:
	Arbitrator.faction.atheneum.house.advisor_card_activation.emit()

func voice_canto() -> void:
	var canto: CantoData = get_canto(Filter.PERFECT)
	var shadow_options: Array[ShadowData]
	
	if canto == null:
		canto = get_canto(Filter.OVERKILL)
	
	if canto == null:
		canto = get_canto(Filter.MAX)
	
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

func get_canto(filter: Filter) -> Variant:
	var cantos: Array[CantoData] = []
	
	for hymn in Arbitrator.faction.odeum.kitchen_scenario.hymns:
		for canto in hymn.cantos:
			match filter:
				Filter.PERFECT:
					if canto.is_perfect:
						cantos.append(canto)
				Filter.OVERKILL:
					for stamp in Arbitrator.faction.atheneum.house.parlor.stamps:
						if canto.pulse_value >= stamp.shadow.current_shade:
							cantos.append(canto)
							break
				Filter.MAX:
					cantos.append(canto)
	
	if not cantos.is_empty():
		cantos.sort_custom(func (a, b): return a.pulse_value > b.pulse_value)
		return cantos.front()
	
	return null

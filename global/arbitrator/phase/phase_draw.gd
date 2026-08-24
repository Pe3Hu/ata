class_name PhaseDraw
extends Phase



func _init() -> void:
	super._init()
	type = Bozo.Phase.DRAW

func enter_phase():
	super.enter_phase()
	
	if Arbitrator.current_round == 1:
		Arbitrator.current_chronicler.house.direct_refill_bedroom()
	
	Arbitrator.current_chronicler.house.refill_parlor()
	
	Arbitrator.current_chronicler.faction.odeum.init_scenarios()
	
	if Arbitrator.is_player():
		status = Bozo.Status.PLAYING_ANIMATION
		Arbitrator.current_chronicler.house.draw_phase.emit()
	else:
		exit_phase()

func _on_all_animations_finished() -> void:
	super._on_all_animations_finished()
	status = Bozo.Status.IDLE
	exit_phase()

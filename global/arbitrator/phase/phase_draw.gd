class_name PhaseDraw
extends Phase



func _init() -> void:
	super._init()
	type = Bozo.Phase.DRAW

func enter_phase():
	super.enter_phase()
	
	if Arbitrator.current_round == 1:
		Arbitrator.faction.atheneum.house.direct_refill_bedroom()
	
	Arbitrator.faction.atheneum.house.refill_parlor()
	Arbitrator.faction.odeum.init_scenarios()
	
	status = Bozo.Status.PLAYING_ANIMATION
	Arbitrator.faction.atheneum.house.draw_phase.emit()

func _on_all_animations_finished() -> void:
	super._on_all_animations_finished()
	status = Bozo.Status.IDLE
	exit_phase()

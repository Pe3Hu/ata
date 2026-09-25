class_name PhaseDraw
extends Phase



func _init() -> void:
	super._init()
	type = Bozo.Phase.DRAW

func enter_phase():
	super.enter_phase()
	
	if Mother.house.bedroom.stamps.size() < 2:
		if Arbitrator.current_round > 1:
			pass
		Mother.house.direct_refill_bedroom()
	
	Mother.house.refill_parlor()
	Mother.odeum.init_scenarios()
	
	status = Bozo.Status.PLAYING_ANIMATION
	Mother.house.draw_phase.emit()

func _on_all_animations_finished() -> void:
	super._on_all_animations_finished()
	status = Bozo.Status.IDLE
	exit_phase()

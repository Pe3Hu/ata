class_name PhaseDraw
extends Phase



func _init() -> void:
	super._init()
	type = Bozo.Phase.DRAW

func enter_phase():
	super.enter_phase()
	
	if Mother.house.bedroom.echos.size() < 2:
		if Arbitrator.current_round > 1:
			Mother.house.refill_bedroom_from_reinforcement()
		else:
			Mother.house.direct_refill_bedroom()
			
	if Arbitrator.current_round > 1 and Mother.house.bedroom.echos.size() < 10:
		Mother.nightmare.admit_defeat.emit()
		return
	
	Mother.house.refill_parlor()
	Mother.odeum.init_scenarios()
	
	status = Bozo.Status.PLAYING_ANIMATION
	Mother.house.draw_phase.emit()
	
	if animation_tweens.is_empty():
		exit_phase()

func _on_all_animations_finished() -> void:
	super._on_all_animations_finished()
	status = Bozo.Status.IDLE
	exit_phase()

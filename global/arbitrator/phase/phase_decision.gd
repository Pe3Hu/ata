class_name PhaseDecision
extends Phase


func _init() -> void:
	super._init()
	type = Bozo.Phase.DECISION

func enter_phase():
	super.enter_phase()
	
	Advisor.apply_choice()

func _on_all_animations_finished() -> void:
	super._on_all_animations_finished()
	
	if Arbitrator.last_action and Arbitrator.last_action.type == Bozo.Action.ATTACK_SHADOW:
		Arbitrator.last_action.animation_left -= 1
		
		if not Arbitrator.last_action:
			Arbitrator.faction.kernel.stepladder.finish_pressure()

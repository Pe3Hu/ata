class_name PhaseFusion
extends Phase


func _init() -> void:
	super._init()
	type = Bozo.Phase.FUSION
	is_waiting_animations = false

func enter_phase():
	super.enter_phase()
	Arbitrator.faction.policy.isle.forge.init_anvils()
	
	if Arbitrator.faction.policy.isle.forge.anvils.is_empty():
		exit_phase()
	else:
		Advisor.apply_choice()

func exit_phase() -> void:
	super.exit_phase()
	Arbitrator.faction.policy.isle.forge.phase_finished.emit()

func _on_all_animations_finished() -> void:
	super._on_all_animations_finished()
	status = Bozo.Status.IDLE
	exit_phase()

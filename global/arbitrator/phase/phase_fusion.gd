class_name PhaseFusion
extends Phase


func _init() -> void:
	super._init()
	type = Bozo.Phase.FUSION
	is_waiting_animations = false

func enter_phase():
	super.enter_phase()
	Mother.arsenal.init_anvils()
	
	if Mother.arsenal.anvils.is_empty():
		exit_phase()
	else:
		if Gear.is_auto_play:
			Advisor.apply_choice()

func exit_phase() -> void:
	Mother.arsenal.phase_finished.emit()
	super.exit_phase()

func _on_all_animations_finished() -> void:
	super._on_all_animations_finished()
	status = Bozo.Status.IDLE
	exit_phase()

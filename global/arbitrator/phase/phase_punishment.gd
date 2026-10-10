class_name PhasePunishment
extends Phase


func _init() -> void:
	super._init() 
	type = Bozo.Phase.PUNISHMENT

func enter_phase():
	super.enter_phase()
	#Arbitrator.faction.odeum.current_scenario = null
	if Mother.house.parlor.echos.is_empty():
		exit_phase()
	else:
		Mother.house.punishment_phase.emit()
		if animation_tweens.is_empty():
			exit_phase()

func exit_phase() -> void:
	Mother.house._on_punishment_phase_end()
	super.exit_phase()

func _on_all_animations_finished() -> void:
	super._on_all_animations_finished()
	status = Bozo.Status.IDLE
	exit_phase()

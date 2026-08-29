class_name PhasePunishment
extends Phase


func _init() -> void:
	super._init()
	type = Bozo.Phase.PUNISHMENT

func enter_phase():
	super.enter_phase()
	Arbitrator.faction.odeum.current_scenario = null
	
	Arbitrator.faction.house.punishment_phase.emit()

func _on_all_animations_finished() -> void:
	super._on_all_animations_finished()
	status = Bozo.Status.IDLE
	exit_phase()

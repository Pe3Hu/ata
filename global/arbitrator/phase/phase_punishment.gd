class_name PhasePunishment
extends Phase


func _init() -> void:
	super._init() 
	type = Bozo.Phase.PUNISHMENT

func enter_phase():
	super.enter_phase()
	#Arbitrator.faction.odeum.current_scenario = null
	if Arbitrator.faction.atheneum.house.parlor.stamps.is_empty():
		#exit_phase()
		pass
	else:
		Arbitrator.faction.atheneum.house.punishment_phase.emit()

func exit_phase() -> void:
	super.exit_phase()
	Arbitrator.faction.atheneum.house._on_punishment_phase_end()

func _on_all_animations_finished() -> void:
	super._on_all_animations_finished()
	status = Bozo.Status.IDLE
	exit_phase()

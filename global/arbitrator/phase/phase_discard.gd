class_name PhaseDiscard
extends Phase


func _init() -> void:
	super._init()
	type = Bozo.Phase.DISCARD

func enter_phase():
	super.enter_phase()
	Arbitrator.current_chronicler.faction.odeum.current_scenario = null
	
	Arbitrator.current_chronicler.tribunal.actual.clear()
	
	if Arbitrator.is_player():
		Arbitrator.current_chronicler.tribunal.atheneum.discard_phase.emit()
	else:
		exit_phase()

func _on_all_animations_finished() -> void:
	super._on_all_animations_finished()
	status = Bozo.Status.IDLE
	exit_phase()

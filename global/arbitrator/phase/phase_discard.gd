class_name PhaseDiscard
extends Phase


func _init() -> void:
	super._init()
	type = Bozo.Phase.DISCARD

func enter_phase():
	super.enter_phase()
	
	Arbitrator.faction.atheneum.house.discard_phase.emit()

class_name PhaseDiscard
extends Phase


func _init() -> void:
	super._init()
	type = Bozo.Phase.DISCARD

func enter_phase():
	super.enter_phase()
	update_forge_stamps()
	
	if Arbitrator.faction.atheneum.house.kitchen.stamps.is_empty():
		exit_phase()
	else: 
		Arbitrator.faction.atheneum.house.kitchen.clear()
		Arbitrator.faction.atheneum.house.discard_phase.emit()

func update_forge_stamps() -> void:
	var forge_stamps: Array[StampData] 
	
	#for stamp in Arbitrator.faction.atheneum.house.kitchen.stamps:
		#forge_stamps.append(stamp)
	forge_stamps.append_array(Arbitrator.faction.atheneum.house.kitchen.stamps)
	
	Arbitrator.faction.policy.isle.forge.stamps = forge_stamps

func _on_all_animations_finished() -> void:
	super._on_all_animations_finished()
	status = Bozo.Status.IDLE
	exit_phase()

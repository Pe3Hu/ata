class_name PhaseDiscard
extends Phase


func _init() -> void:
	super._init()
	type = Bozo.Phase.DISCARD

func enter_phase():
	super.enter_phase()
	update_forge_echos()
	
	if Arbitrator.faction.atheneum.house.kitchen.echos.is_empty():
		exit_phase()
	else: 
		Arbitrator.faction.atheneum.house.kitchen.clear()
		Arbitrator.faction.atheneum.house.discard_phase.emit()

func update_forge_echos() -> void:
	var forge_echos: Array[EchoData] 
	
	#for echo in Arbitrator.faction.atheneum.house.kitchen.echos:
		#forge_echos.append(echo)
	forge_echos.append_array(Arbitrator.faction.atheneum.house.kitchen.echos)
	
	Arbitrator.faction.policy.isle.forge.echos = forge_echos

func _on_all_animations_finished() -> void:
	super._on_all_animations_finished()
	status = Bozo.Status.IDLE
	exit_phase()

class_name PhaseDiscard
extends Phase


func _init() -> void:
	super._init()
	type = Bozo.Phase.DISCARD

func enter_phase():
	super.enter_phase()
	update_forge_echos()
	
	if Mother.house.kitchen.echos.is_empty():
		exit_phase()
	else: 
		Mother.house.kitchen.clear()
		Mother.house.discard_phase.emit()

func update_forge_echos() -> void:
	var forge_echos: Array[EchoData] 
	
	#for echo in Mother.house.kitchen.echos:
		#forge_echos.append(echo)
	forge_echos.append_array(Mother.house.kitchen.echos)
	
	Mother.arsenal.echos = forge_echos

func _on_all_animations_finished() -> void:
	super._on_all_animations_finished()
	status = Bozo.Status.IDLE
	exit_phase()

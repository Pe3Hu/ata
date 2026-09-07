class_name ChoiceFusion
extends Choice


func _init() -> void:
	super._init()
	type = Bozo.Phase.FUSION

func enter_choice():
	super.enter_choice()
	Arbitrator.faction.policy.isle.forge.simulate_anvil_choice()

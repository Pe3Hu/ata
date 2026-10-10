class_name ChoiceFusion
extends Choice


func _init() -> void:
	super._init()
	type = Bozo.Phase.FUSION

func enter_choice():
	super.enter_choice()
	Mother.arsenal.simulate_anvil_choice()

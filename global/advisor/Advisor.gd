extends Node


var phase_to_choice: Dictionary


func _ready() -> void:
	phase_to_choice[Bozo.Phase.DECISION] = ChoiceDecision.new()
	phase_to_choice[Bozo.Phase.FUSION] = ChoiceFusion.new()

func queue_an_animation(tween_: Tween) -> void:
	var choice = get_choice()
	choice.animation_tweens.append(tween_)
	tween_.finished.connect(choice._on_tween_finished.bind(tween_))

func apply_choice() -> void:
	var choice = get_choice()
	choice.enter_choice()

func get_choice() -> Choice:
	return phase_to_choice[Arbitrator.current_phase.type]

class_name Choice
extends Resource


signal all_animations_finished

var type: Bozo.Phase
var status: Bozo.Status = Bozo.Status.IDLE

var animation_tweens: Array[Tween]

var is_waiting_animations: bool = true


func _init() -> void:
	all_animations_finished.connect(_on_all_animations_finished)

func enter_choice() -> void:
	pass

func exit_choice() -> void:
	Arbitrator.current_phase.exit_phase()

func _on_tween_finished(tween_: Tween) -> void:
	animation_tweens.erase(tween_)
	
	if animation_tweens.is_empty():
		all_animations_finished.emit()

func _on_all_animations_finished() -> void:
	exit_choice()

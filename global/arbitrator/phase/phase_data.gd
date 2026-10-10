class_name Phase
extends Resource


signal phase_completed

var type: Bozo.Phase
var status: Bozo.Status = Bozo.Status.IDLE

var animation_tweens: Array[Tween]
var animation_epoch: int = 0

var is_waiting_animations: bool = true


func _init() -> void:
	pass

func enter_phase() -> void:
	print(Bozo.enum_to_string(Bozo.Type.PHASE, type))
	pass

func exit_phase() -> void:
	phase_completed.emit()

func can_execute_action(_action: ActionData) -> bool:
	if Arbitrator.last_action:
		return false
	
	return true

func try_execute_action(action: ActionData) -> bool:
	if not can_execute_action(action):
		return false

	action.execute()
	return true

func drop_animations() -> void:
	animation_epoch += 1
	animation_tweens.clear()

func _on_tween_finished(tween_: Tween, epoch_: int) -> void:
	if epoch_ != animation_epoch:
		return
	
	animation_tweens.erase(tween_)
	
	if animation_tweens.is_empty():
		if not is_waiting_animations: 
			return
		
		_on_all_animations_finished()

func _on_all_animations_finished() -> void:
	pass

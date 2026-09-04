class_name ImpulseData
extends RefCounted


signal value_changed

var attempt: AttemptData
var method: Bozo.Method
var value: int = 0:
	set(value_):
		value = value_
		value_changed.emit()


func _init(attempt_: AttemptData, method_: Bozo.Method) -> void:
	attempt = attempt_
	method = method_
	
	attempt.method_to_impulse[method] = self
	attempt.impulses.append(self)
	
	if attempt.gang.attempt == null:
		attempt.gang.mission.bank.type_to_method[method].impulse = self

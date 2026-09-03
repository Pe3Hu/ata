class_name ImpulseData
extends RefCounted


var attempt: AttemptData
var method: Bozo.Method
var value: int


func _init(attempt_: AttemptData, method_: Bozo.Method) -> void:
	attempt = attempt_
	method = method_

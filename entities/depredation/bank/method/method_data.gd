class_name MethodData
extends RefCounted


signal difficulty_changed
 
var obstacle: ObstacleData
var type: Bozo.Method
var methods: Array[Bozo.Method]

var current_difficulty: int:
	set(value_):
		current_difficulty = value_
		difficulty_changed.emit()
var impulse: ImpulseData


func _init(obstacle_: ObstacleData, type_: Bozo.Method) -> void:
	obstacle = obstacle_
	type = type_
	
	obstacle.methods.append(self)
	obstacle.ruin.bank.methods.append(self)
	obstacle.ruin.bank.type_to_method[type] = self
	current_difficulty = obstacle.limit_difficulty
	
	var attempt = obstacle.ruin.bank.depredation.gang.attempt
	if attempt:
		impulse = attempt.method_to_impulse[type]

func execute() -> void:
	current_difficulty -= impulse.value
	obstacle.ruin.bank.depredation.gang.attempt.implement()

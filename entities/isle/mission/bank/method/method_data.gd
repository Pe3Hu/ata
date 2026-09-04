class_name MethodData
extends RefCounted


signal difficulty_changed

var obstacle: ObstacleData
var type: Bozo.Method
var methods: Array[Bozo.Method]

var difficulty: int:
	set(value_):
		difficulty = value_
		difficulty_changed.emit()
var impulse: ImpulseData


func _init(obstacle_: ObstacleData, type_: Bozo.Method) -> void:
	obstacle = obstacle_
	type = type_
	
	obstacle.methods.append(self)
	obstacle.bank.methods.append(self)
	obstacle.bank.type_to_method[type] = self

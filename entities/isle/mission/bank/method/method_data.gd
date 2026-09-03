class_name MethodData
extends RefCounted


var obstacle: ObstacleData
var type: Bozo.Method
var methods: Array[Bozo.Method]

var impulse: int


func _init(obstacle_: ObstacleData, type_: Bozo.Method) -> void:
	obstacle = obstacle_
	type = type_
	
	obstacle.methods.append(self)
	obstacle.bank.methods.append(self)

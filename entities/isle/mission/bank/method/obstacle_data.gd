class_name ObstacleData
extends RefCounted



var bank: BankData
var type: Bozo.Obstacle

var mandate: Bozo.Mandate
var methods: Array[MethodData]

var limit_difficulty: int:
	set(value_):
		limit_difficulty = value_
		
		for method in methods:
			method.current_difficulty = limit_difficulty


func _init(bank_: BankData, type_: Bozo.Obstacle) -> void:
	bank = bank_
	type = type_
	
	bank.obstacles.append(self)
	bank.type_to_method[type] = self
	
	init_methods()

func init_methods() -> void:
	for method_type in Digest.obstacle_to_methods[type]:
		var _method = MethodData.new(self, method_type)

class_name ObstacleData
extends RefCounted


var bank: BankData
var type: Bozo.Obstacle

var mandate: Bozo.Mandate
var methods: Array[MethodData]

var current_difficulty: int
var limit_difficulty: int


func _init(bank_: BankData, type_: Bozo.Obstacle) -> void:
	bank = bank_
	type = type_
	
	init_methods()

func init_methods() -> void:
	for method_type in Digest.obstacle_to_methods[type]:
		var _method = MethodData.new(self, method_type)

class_name ObstacleData
extends Resource


var bank: BankData
var type: Bozo.Obstacle
var mandat: Bozo.Mandate
var methods: Array[Bozo.Method]


func _init(bank_: BankData, type_: Bozo.Obstacle) -> void:
	bank = bank_
	type = type_

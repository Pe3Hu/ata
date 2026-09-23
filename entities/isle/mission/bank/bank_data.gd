class_name BankData
extends RefCounted


var mission: MissionData
var ruin: RuinData:
	set(value_):
		ruin = value_
		ruin.bank = self
		init_methods()

var methods: Array[MethodData]
var type_to_method: Dictionary


func _init(mission_: MissionData) -> void:
	mission = mission_

func init_methods() -> void:
	for obstacle in ruin.obstacles:
		for method_type in Digest.obstacle_to_methods[obstacle.type]:
			var _method = MethodData.new(obstacle, method_type)
	
	methods.sort_custom(func (a, b): return Catalog.methods.find(a.type) < Catalog.methods.find(b.type))

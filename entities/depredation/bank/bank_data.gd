class_name BankData
extends RefCounted


var depredation: DepredationData
var ruin: RuinData:
	set(value_):
		ruin = value_
		ruin.bank = self
		Mother.cottage.refill_kitchen()
		depredation.gang.galore.recalc_potentials()
		init_methods()
		depredation.gang.init_plans()

var methods: Array[MethodData]
var type_to_method: Dictionary


func _init(depredation_: DepredationData) -> void:
	depredation = depredation_

func init_methods() -> void:
	for obstacle in ruin.obstacles:
		obstacle.methods.clear()
	
	methods.clear()
	type_to_method.clear()
	
	for obstacle in ruin.obstacles:
		for method_type in Digest.obstacle_to_methods[obstacle.type]:
			MethodData.new(obstacle, method_type)
	
	methods.sort_custom(func (a, b): return Catalog.methods.find(a.type) < Catalog.methods.find(b.type))

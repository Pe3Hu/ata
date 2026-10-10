class_name MethodData
extends RefCounted


signal difficulty_changed
 
var obstacle: ObstacleData
var type: Bozo.Method
var methods: Array[Bozo.Method]

var current_difficulty: int:
	set(value_):
		current_difficulty = value_
		
		if current_difficulty <= 0:
			Mother.depredation.obstacle_cleared.emit(obstacle)
		
		difficulty_changed.emit()
var impulse: ImpulseData
var intentions: Array[IntentionData]


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
	
	init_intentions()


func init_intentions() -> void:
	var factors = [2, 1]
	
	for factor in factors:
		var intention = IntentionData.new()
		intention.aspect = Digest.method_to_factor_to_aspect[type][factor]
		intention.element = Digest.method_to_element[type]
		intention.suffix = Bozo.Suffix.MULTIPLY
		intention.value = factor
		intentions.append(intention)
	
func execute() -> void:
	current_difficulty -= impulse.value
	obstacle.ruin.bank.depredation.gang.attempt.implement()

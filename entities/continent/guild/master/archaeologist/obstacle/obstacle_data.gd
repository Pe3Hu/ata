class_name ObstacleData
extends RefCounted


var ruin: RuinData
var type: Bozo.Obstacle

var vulnerability: Bozo.Element
var resilience: Bozo.Element

var mandate: Bozo.Mandate
var methods: Array[MethodData]

var order_difficulty: int:
	set(value_):
		order_difficulty = value_
		
		limit_difficulty = Catalog.AVG_OBSTACLE_DIFFICULTY + Catalog.difficulty_shifts[order_difficulty]
var limit_difficulty: int:
	set(value_):
		limit_difficulty = value_
		
		for method in methods:
			method.current_difficulty = limit_difficulty


func _init(ruin_: RuinData, type_: Bozo.Obstacle) -> void:
	ruin = ruin_
	type = type_
	
	ruin.obstacles.append(self)
	ruin.type_to_obstacle[type] = self
	roll_elements()

func roll_elements() -> void:
	var elements: Array[Bozo.Element]
	
	for method in Digest.obstacle_to_methods[type]:
		elements.append(Digest.method_to_element[method])
	
	elements.shuffle()
	vulnerability = elements[0]
	resilience = elements[1]

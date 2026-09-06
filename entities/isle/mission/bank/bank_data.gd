class_name BankData
extends RefCounted


var mission: MissionData


var type_to_obstacle: Dictionary
var obstacles: Array[ObstacleData]

var methods: Array[MethodData]
var type_to_method: Dictionary


func _init(mission_: MissionData) -> void:
	mission = mission_
	
	init_obstacles()

func init_obstacles() -> void:
	for obstacle_type in Catalog.obstacles:
		var _obstacle = ObstacleData.new(self, obstacle_type)
	
	methods.sort_custom(func (a, b): return Catalog.methods.find(a.type) < Catalog.methods.find(b.type))
	roll_obstacles_difficulty()

func roll_obstacles_difficulty() -> void:
	var shifts = Catalog.difficulty_shifts.duplicate()
	shifts.shuffle()
	
	for _i in shifts.size():
		var obstacle = obstacles[_i]
		obstacle.limit_difficulty = Catalog.AVG_OBSTACLE_DIFFICULTY + shifts[_i]

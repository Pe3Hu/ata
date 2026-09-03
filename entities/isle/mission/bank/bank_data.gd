class_name BankData
extends RefCounted


var mission: MissionData

var lock: ObstacleData
var wall: ObstacleData
var custodian: ObstacleData

var methods: Array[MethodData]

var avg_difficulty: int = 10


func _init(mission_: MissionData) -> void:
	mission = mission_
	
	lock = ObstacleData.new(self, Bozo.Obstacle.LOCK)
	wall = ObstacleData.new(self, Bozo.Obstacle.WALL)
	custodian = ObstacleData.new(self, Bozo.Obstacle.CUSTODIAN)

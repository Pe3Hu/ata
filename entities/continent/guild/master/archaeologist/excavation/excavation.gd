class_name Excavation
extends Task


var obstacle_scene = preload('uid://bvlxni1icaq4a')


func connect_signals() -> void:
	super.connect_signals()
	init_obstacles()
	%Loot.data = data.ruin.loot

func init_obstacles() -> void:
	Helper.clear_children(%Obstacles)
	
	for obstacle_data in data.ruin.obstacles:
		add_obstacle(obstacle_data)

func add_obstacle(obstacle_data_: ObstacleData) -> void:
	var obstacle = obstacle_scene.instantiate()
	%Obstacles.add_child(obstacle)
	obstacle.data = obstacle_data_

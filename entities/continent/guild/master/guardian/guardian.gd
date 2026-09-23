class_name Guardian
extends Master


var obstacle_scene = preload('uid://bvlxni1icaq4a')

func _ready() -> void:
	data = Mother.guild.guardian
	super._ready()
	init_obstacles()

func init_obstacles() -> void:
	Helper.clear_children(%Obstacles)
	
	for obstacle_data in data.get_ruin().obstacles:
		add_obstacle(obstacle_data)

func add_obstacle(obstacle_data_: ObstacleData) -> void:
	var obstacle = obstacle_scene.instantiate()
	%Obstacles.add_child(obstacle)
	obstacle.data = obstacle_data_

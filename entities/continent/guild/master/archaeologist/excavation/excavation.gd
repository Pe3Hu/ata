class_name Excavation
extends Task


var obstacle_scene = preload('uid://bvlxni1icaq4a')
var spoil_scene = preload('uid://c2j2ueheonqnf')
var spark_scene = preload('uid://dxf630vjxmpad')


func connect_signals() -> void:
	super.connect_signals()
	init_obstacles()
	init_spoils()
	init_sparks()

func init_obstacles() -> void:
	Helper.clear_children(%Obstacles)
	
	for obstacle_data in data.ruin.obstacles:
		add_obstacle(obstacle_data)

func add_obstacle(obstacle_data_: ObstacleData) -> void:
	var obstacle = obstacle_scene.instantiate()
	%Obstacles.add_child(obstacle)
	obstacle.data = obstacle_data_

func init_spoils() -> void:
	Helper.clear_children(%Spoils)
	
	for spoil_data in data.ruin.spoils:
		add_spoil(spoil_data)

func add_spoil(spoil_data_: SpoilData) -> void:
	var spoil = spoil_scene.instantiate()
	%Spoils.add_child(spoil)
	spoil.data = spoil_data_

func init_sparks() -> void:
	Helper.clear_children(%Sparks)
	
	for spark_data in data.ruin.sparks:
		add_spark(spark_data)

func add_spark(spark_data_: SparkData) -> void:
	var spark = spark_scene.instantiate()
	%Sparks.add_child(spark)
	spark.data = spark_data_

class_name RuinData
extends StructureData


var bank: BankData
var matter: Bozo.Matter

var type_to_obstacle: Dictionary
var obstacles: Array[ObstacleData]


func _init(cluster_: ClusterData, type_: Bozo.Structure, coord_: Vector2i = Vector2i.ZERO) -> void:
	super._init(cluster_, type_, coord_)
	init_obstacles()

func init_obstacles() -> void:
	for obstacle_type in Catalog.obstacles:
		var _obstacle = ObstacleData.new(self, obstacle_type)
	
	roll_obstacles_difficulty()

func roll_obstacles_difficulty() -> void:
	var shifts = Catalog.difficulty_shifts.duplicate()
	shifts.shuffle()
	
	for _i in shifts.size():
		var obstacle = obstacles[_i]
		obstacle.order_difficulty = Catalog.difficulty_shifts.find(shifts[_i])
		#obstacle.limit_difficulty = Catalog.AVG_OBSTACLE_DIFFICULTY + shifts[_i]
	
	obstacles.sort_custom(func (a, b): return a.order_difficulty > b.order_difficulty)

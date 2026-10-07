class_name RuinData
extends StructureData


var bank: BankData
var loot: LootData
var matter: Bozo.Matter

var type_to_obstacle: Dictionary
var obstacles: Array[ObstacleData]


func reorder(order_: int) -> void:
	order = order_
	init_obstacles()
	loot = LootData.new(self)

func init_obstacles() -> void:
	obstacles.clear()
	for obstacle_type in Catalog.obstacles:
		ObstacleData.new(self, obstacle_type)
	
	roll_obstacles_difficulty()

func roll_obstacles_difficulty() -> void:
	var shifts = Catalog.difficulty_shifts.duplicate()
	shifts.shuffle()
	
	for _i in shifts.size():
		var obstacle = obstacles[_i]
		obstacle.order_difficulty = Catalog.difficulty_shifts.find(shifts[_i])
		#obstacle.limit_difficulty = Catalog.AVG_OBSTACLE_DIFFICULTY + shifts[_i]
	
	obstacles.sort_custom(func (a, b): return a.order_difficulty > b.order_difficulty)

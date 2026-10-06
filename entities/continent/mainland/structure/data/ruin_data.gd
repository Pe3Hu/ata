class_name RuinData
extends StructureData


var bank: BankData
var matter: Bozo.Matter

var type_to_obstacle: Dictionary
var obstacles: Array[ObstacleData]

var spoils: Array[SpoilData]
var sparks: Array[SparkData]


func reorder(order_: int) -> void:
	order = order_
	init_obstacles()
	init_spoils()
	init_sparks()

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

func init_sparks() -> void:
	sparks.clear()
	var volume_to_amount = Digest.ruin_to_sparks[order].pick_random()
	
	for volume in volume_to_amount:
		var amount = volume_to_amount[volume]
		var spark = SparkData.new(volume, amount)
		sparks.append(spark)

func init_spoils() -> void:
	var total_spoil_amount: int = Digest.master_to_price[Bozo.Master.ARCHAEOLOGIST] * (order + 1) * Catalog.ARCHAEOLOGIST_SPOIL_FACTOR
	var default_spoil_sum = total_spoil_amount * 0.25
	var volume = Digest.matter_to_volumes[matters.back()][0]
	var amount = ceil(float(default_spoil_sum) / volume)
	var spoil = SpoilData.new(matters.front(), volume, amount)
	spoils.append(spoil)
	var volume_options = Digest.matter_to_volumes[matters.back()].duplicate()
	volume_options.pop_front()
	volume = volume_options.pick_random()
	amount = ceil(float(default_spoil_sum) / volume)
	spoil = SpoilData.new(matters.back(), volume, amount)
	spoils.append(spoil)
	
	for _spoil in spoils:
		total_spoil_amount -= _spoil.amount * _spoil.shard.volume
	
	var spoil_index := 0
	
	while total_spoil_amount > 0:
		var _spoil = spoils[spoil_index]
		var max_amount = ceil(60.0 / _spoil.shard.volume)
		amount = Helper.rng.randi_range(1, max_amount)
		
		if amount * _spoil.shard.volume > total_spoil_amount:
			amount = max(floor(float(total_spoil_amount) / _spoil.shard.volume), 0)
		
		_spoil.amount += amount
		total_spoil_amount -= amount * _spoil.shard.volume
		spoil_index = (spoil_index + 1) % spoils.size()
		
		if amount == 0: break
	
	var check_sum := Digest.master_to_price[Bozo.Master.ARCHAEOLOGIST] * (order + 1) * Catalog.ARCHAEOLOGIST_SPOIL_FACTOR
	
	for _spoil in spoils:
		check_sum -= _spoil.amount * _spoil.shard.volume
	
	amount = ceil(float(check_sum) / spoils.front().shard.volume)
	spoils.front().amount += amount
	check_sum -= amount * spoils.front().shard.volume

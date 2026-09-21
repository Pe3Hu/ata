extends Camera2D


@export var mainland: Mainland
@export var tile_size: Vector2 = Vector2(48, 48) # Размер тайла
@export var move_speed: float = 4.0 # Скорость перемещения камеры

var target_position: Vector2


func _ready():
	position_smoothing_speed = move_speed

func focus_on_structure() -> void:
	if mainland.data.route.finish_structure == null: return
	target_position = Helper.get_structure_position(mainland.data.route.finish_structure, true)

func _process(delta: float) -> void:
	if mainland.data.route.finish_structure:
		global_position = lerp(global_position, target_position, delta * move_speed)

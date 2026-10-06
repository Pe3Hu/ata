class_name Hourglass
extends PanelContainer


@export var rotation_speed: float = 0.5

var is_active: bool = false


func _ready() -> void:
	rotation_speed = Gear.hourglass[Gear.tempo]

func _process(delta: float) -> void:
	if not is_active: return
	Mother.guild.hourglass_time += rotation_speed * delta
	var current_angle = fposmod(Mother.guild.hourglass_time, 1.0) * TAU
	offset_transform_rotation = current_angle
	%Body.material.set_shader_parameter("angle", current_angle)

func _on_button_pressed() -> void:
	if Mother.mainland.route.finish_structure == null or Mother.mainland.route.finish_structure == Mother.mainland.route.start_structure:
		start_depredation()
		return
	
	Mother.mainland.footprint.route_started.emit()

func start_depredation() -> void:
	if Mother.mainland.route.start_structure.type != Bozo.Structure.RUIN: return
	Mother.depredation.bank.ruin = Mother.mainland.route.start_structure
	get_tree().change_scene_to_file("res://entities/depredation/depredation.tscn")

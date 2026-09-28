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

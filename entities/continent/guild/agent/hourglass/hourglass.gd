class_name Hourglass
extends PanelContainer


@export var rotation_speed: float = 0.1


func _process(delta: float) -> void:
	Mother.guild.hourglass_time += rotation_speed * delta
	var current_angle = fmod(Mother.guild.hourglass_time, 1.0) * TAU
	offset_transform_rotation = current_angle
	%Body.material.set_shader_parameter("angle", current_angle)

class_name Pulse
extends PanelContainer


@export var canto: Canto

@export var icon: TextureRect


func _on_value_changed() -> void:
	%Number.texture = load("res://entities/dice/images/%d.png" % canto.data.pulse_value)

func _on_is_perfect_changed() -> void:
	icon.material.set_shader_parameter("is_perfect", canto.data.is_perfect)

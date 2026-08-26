class_name Pulse
extends PanelContainer


@export var canto: Canto

@export var value: int = 0:
	set(value_):
		value = value_
		
		%Number.texture = load("res://entities/dice/images/%d.png" % value)

@export var icon: TextureRect


func _on_is_critical_changed() -> void:
	icon.material.set_shader_parameter("is_critical", canto.data.is_critical)

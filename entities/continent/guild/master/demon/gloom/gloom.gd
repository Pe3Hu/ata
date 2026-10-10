class_name Gloom
extends PanelContainer


@export var value: Label


func _ready() -> void:
	%Body.material.set_shader_parameter('base_color', Digest.element_to_color[Bozo.Element.CHAOS])

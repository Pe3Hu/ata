class_name Clock
extends ColorRect




func _ready() -> void:
	Mother.clock_updated.connect(_on_clock_updated)
	_on_clock_updated(Mother.clock.get_hand_angle())

func _on_clock_updated(angle: float) -> void:
	material.set_shader_parameter("hand_angle", angle)

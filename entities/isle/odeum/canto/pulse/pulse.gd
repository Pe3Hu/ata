class_name Pulse
extends PanelContainer


@export var canto: Canto


func _ready() -> void:
	%Body.hover_scale = Vector2(1.1, 1.1)

func _on_value_changed() -> void:
	%Number.texture = load("res://entities/dice/images/%d.png" % canto.data.pulse_value)

func _on_is_perfect_changed() -> void:
	%Body.material.set_shader_parameter("is_perfect", canto.data.is_perfect)

func _on_is_selected_changed() -> void:
	var bg_color: Color = Digest.canto_to_selection[canto.data.is_selected]
	%Body.material.set_shader_parameter("bg_color", bg_color)

func _on_body_pressed() -> void:
	canto.update_selection()

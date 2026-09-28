extends PanelContainer


var is_locked := false


func _on_button_pressed() -> void:
	is_locked = not is_locked
	update_textures()

func update_textures() -> void:
	if is_locked:
		%Button.texture_normal = preload("uid://dyhnuea3y1a4l")
		%Button.texture_hover  = preload("uid://b72sd1i2dgnu1")
	else:
		%Button.texture_normal = preload("uid://b8733ha1tlasv")
		%Button.texture_hover  = preload("uid://dm8qufe13tojk")

func apply_matter(matter_: Bozo.Matter) -> void:
	Helper.update_matter_colors(%Button, [matter_])

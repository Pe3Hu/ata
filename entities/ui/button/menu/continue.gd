extends CustomTextButton



func _button_pressed() -> void:
	get_tree().change_scene_to_file("res://entities/continent/continent.tscn")

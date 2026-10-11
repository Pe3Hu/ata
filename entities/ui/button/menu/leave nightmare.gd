extends CustomTextButton


func _button_pressed() -> void:
	Mother.nightmare.slumber.rift.demolish()
	get_tree().change_scene_to_file("res://entities/continent/continent.tscn")

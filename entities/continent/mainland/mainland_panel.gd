extends SubViewportContainer

func _input(event: InputEvent) -> void:
	for view_child in get_children():
		if view_child is SubViewport:
			for node2d_child in view_child.get_children():
				if node2d_child is Node2D:
					node2d_child._on_continent_gui_input(event)
	

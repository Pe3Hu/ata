class_name FocusMark
extends Node

## Child of a Control or Node2D. Registers that parent so Focus can aim it
## by this node or by focus_id. Use on Master panels and buttons.

@export var focus_id := ""
@export var padding := -1.0
@export var radius := -1.0
@export_enum("Rounded", "Circle") var shape := 0
@export var visual_path: NodePath


func _ready() -> void:
	var visual := _visual()
	if visual == null:
		return

	Focus.register(self, visual, padding, radius, shape)
	if focus_id != "":
		Focus.register(focus_id, visual, padding, radius, shape)


func _exit_tree() -> void:
	if not is_instance_valid(Focus):
		return
	Focus.unregister(self)
	if focus_id != "":
		Focus.unregister(focus_id)


func _visual() -> CanvasItem:
	if not visual_path.is_empty():
		var pointed := get_node_or_null(visual_path)
		if pointed is CanvasItem:
			return pointed

	var parent := get_parent()
	if parent is CanvasItem:
		return parent
	return null

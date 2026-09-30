class_name Firework
extends Task



func connect_signals() -> void:
	super.connect_signals()
	apply_shelters()

func _on_task_changed() -> void:
	super._on_task_changed()
	apply_shelters()

func apply_shelters() -> void:
	data.tinted_shelters = data.get_tinted_shelters()
	%Circuit.update_markers(data.tinted_shelters)

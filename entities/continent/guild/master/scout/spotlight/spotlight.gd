class_name Spotlight
extends Task


var master: Master


func connect_signals() -> void:
	super.connect_signals()
	apply_shelter()

func _on_task_changed() -> void:
	super._on_task_changed()
	apply_shelter()

func apply_shelter() -> void:
	Mother.mainland.beam.update_shelters()
	var camera = master.guild.mainland.camera
	camera.focus_on_structure(data.shelter.shrine)
	%Circuit.marker_shelter = data.shelter

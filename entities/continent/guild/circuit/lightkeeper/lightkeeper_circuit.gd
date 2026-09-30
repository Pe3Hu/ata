class_name LightkeeperCircuit
extends Circuit


func connect_signals() -> void:
	Mother.guild.scout.internals_changed.connect(_on_internals_changed)
	_on_internals_changed()

func _on_internals_changed() -> void:
	var donor_points := PackedVector2Array()
	
	for shelter in Mother.guild.scout.internals:
		donor_points.append(Helper.get_cluster_position(shelter))
	
	apply_donors(donor_points)

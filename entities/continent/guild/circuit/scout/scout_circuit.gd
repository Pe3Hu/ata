class_name ScoutCircuit
extends Circuit


func connect_signals() -> void:
	Mother.guild.scout.extrenals_changed.connect(_on_extrenals_changed)
	_on_extrenals_changed()

func _on_extrenals_changed() -> void:
	var donor_points := PackedVector2Array()
	
	for shelter in Mother.guild.scout.extrenals:
		donor_points.append(Helper.get_cluster_position(shelter))
	
	apply_donors(donor_points)

class_name Shrine
extends Structure



#region init
func connect_signals() -> void:
	data.haze_changed.connect(_on_haze_changed)
	_on_haze_changed()
	data.illuminate_changed.connect(_on_illuminate_changed)
	_on_illuminate_changed()

func _on_haze_changed() -> void:
	%Torch.visible = not data.is_hazed

func _on_illuminate_changed() -> void:
	%Flame.visible = data.is_illuminated
#endregion

func _on_area_mouse_entered() -> void:
	super._on_area_mouse_entered()
	
	#if is_available_for_llumination():
		#data.cluster.mainland.beam.next_shelter = data.cluster

func _on_area_mouse_exited() -> void:
	super._on_area_mouse_exited()
	
	#data.cluster.mainland.beam.next_shelter = null

func is_available_for_llumination() -> bool:
	if data.cluster.mainland.beam.current_shelter == data.cluster: return false
	if not data.cluster.mainland.beam.current_shelter.neighbor_shelters.has(data.cluster): return false
	return true

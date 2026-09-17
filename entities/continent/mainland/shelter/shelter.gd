class_name Shelter
extends Node2D


var data: ShelterData:
	set(value_):
		data = value_
		
		connect_signals()
		position = data.center * Catalog.MAINLAND_CELL_SIZE


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

func _on_body_area_mouse_entered() -> void:
	scale = Vector2.ONE * 1.1
	
	if is_available_for_llumination():
		data.mainland.beam.second_shelter = data

func _on_body_area_mouse_exited() -> void:
	scale = Vector2.ONE * 1
	data.mainland.beam.second_shelter = null

func is_available_for_llumination() -> bool:
	if data.mainland.beam.first_shelter == data: return false
	if not data.mainland.beam.first_shelter.neighbor_shelters.has(data): return false
	return true

class_name Haze
extends Sprite2D

var data: HazeData:
	set(value_):
		data = value_
		
		connect_signals()

func connect_signals() -> void:
	if data == null:
		texture = null
		return
	
	if data.changed.is_connected(_on_data_changed):
		data.changed.disconnect(_on_data_changed)
	
	data.changed.connect(_on_data_changed)
	_on_data_changed()
	data.reveal_shelter_then_neighbors_wave()

func _on_data_changed() -> void:
	if data == null: return
	texture = data.fog_texture
	scale = Vector2(data.fog_pixelation, data.fog_pixelation)
	centered = false
	position = data.world_position

func _process(delta: float) -> void:
	if data != null:
		data.tick(delta)

func _unhandled_input(event: InputEvent) -> void:
	if not (event is InputEventKey and event.pressed and not event.echo):
		return
	if data == null:
		push_warning("Haze: data is null, nothing to reveal")
		return

	match event.physical_keycode:
		#KEY_Q:
			#data.reveal_first_shelter_wave()
		#KEY_W:
			#data.reveal_first_wasteland_wave()
		KEY_A:
			data.reveal_shelter_then_neighbors_wave()
		KEY_SPACE:
			data.trigger_periphery_erosion()

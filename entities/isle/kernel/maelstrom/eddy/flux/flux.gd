class_name Flux
extends PanelContainer


var data:
	set(value_):
		data = value_
		
		connect_signals()
		upadete_position()

@export var eddy: Eddy
@export var value_label: Label


func connect_signals() -> void:
	data.volume_changed.connect(_on_volume_changed)
	_on_volume_changed()

func _on_volume_changed() -> void:
	var crown = Digest.flux_to_crown[data.volume]
	var index = Digest.flux_to_index[data.volume]
	
	%Background.texture_normal = load('res://entities/isle/kernel/maelstrom/eddy/crown/%d.png' % crown)
	%Background.texture_pressed = load('res://entities/isle/kernel/maelstrom/eddy/crown/%d.png' % crown)
	%Background.texture_hover = load('res://entities/isle/kernel/maelstrom/eddy/crown/%d.png' % crown)
	
	%Body.polygon = Digest.crown_to_face_to_points[crown][index]
	%Border.points = Digest.crown_to_face_to_bordes[crown]

func upadete_position() -> void:
	var index = Digest.element_to_index[data.eddy.element] - 1
	var angle = TAU / 6 * index  
	visible = true
	offset_transform_position = Vector2.from_angle(angle) * Catalog.SHARD_RADIUS #+ Catalog.EDDY_SIZE / 2 
	#offset_transform_rotation = angle
	#value_label.offset_transform_rotation = -angle
	%Background.material.set_shader_parameter('base_color', Digest.element_to_color[data.eddy.element])
	#if index == 1:
		#var arr = []
		#var shift = Vector2(23/3, 26/3)
		#
		#for point in %Border5.points:
			#arr.append(point + shift)
		#print(arr)

func _input(event) -> void:
	if event is InputEventKey and event.pressed and not event.echo:
		match event.keycode:
			KEY_Q:
				if data and data.eddy:
					var eddy_index = Digest.element_to_index[data.eddy.element] - 1
					
					if eddy_index == 1:
						var flux_index = Catalog.volumes.find(data.volume) + 1
						data.volume = Catalog.volumes[flux_index]
				pass


func _on_background_mouse_entered() -> void:
	data.eddy.maelstrom.kernel.stepladder.flux = data

func _on_background_mouse_exited() -> void:
	data.eddy.maelstrom.kernel.stepladder.flux = null

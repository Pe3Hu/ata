class_name Eddy
extends TextureRect


var data: EddyData:
	set(value_):
		data = value_
		
		connect_signals()
		#self_modulate = Digest.element_to_color[data.element]
		material.set_shader_parameter('base_color', Digest.element_to_color[data.element])
		#material.set_shader_parameter('base_hue', Digest.element_to_color[data.element].h)
		#material.set_shader_parameter('base_saturation', Digest.element_to_color[data.element].s)
		#material.set_shader_parameter('base_value', Digest.element_to_color[data.element].v)
		var index = Digest.element_to_index[data.element] - 1
		
		if index >= 0:
			var angle = TAU / 6 * index  
			position = Vector2.from_angle(angle) * Catalog.EDDY_RADIUS
			%Flux.data = data.flux

@export var maelstrom: Maelstrom


func connect_signals() -> void:
	data.value_changed.connect(_on_value_changed)
	_on_value_changed()

func _on_value_changed() -> void:
	%Value.text = str(data.current_value)

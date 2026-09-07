class_name Eddy
extends TextureRect


var data: EddyData:
	set(value_):
		data = value_
		
		connect_signals()
		self_modulate = Digest.element_to_color[data.element]
		var index = Digest.element_to_index[data.element] - 1
		
		if index >= 0:
			var angle = TAU / 6 * index  
			position = Vector2.from_angle(angle) * Catalog.EDDY_RADIUS


func connect_signals() -> void:
	data.value_changed.connect(_on_value_changed)
	_on_value_changed()

func _on_value_changed() -> void:
	%Value.text = str(data.current_value)

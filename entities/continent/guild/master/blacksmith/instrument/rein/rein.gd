class_name Rein
extends PanelContainer


var data: ReinData:
	set(value_):
		data = value_
		
		connect_signals()
		update_colors()



func connect_signals() -> void:
	data.volume_changed.connect(_on_volue_changed)
	_on_volue_changed()

func _on_volue_changed() -> void:
	var suffix = Bozo.enum_to_string(Bozo.Type.SUFFIX, data.suffix, true)
	var text = suffix + str(data.volume)
	%Value.text = text
	
	if text.length() > 3:
		%Value.label_settings.font_size = 20
	else:
		%Value.label_settings.font_size = 24

func update_colors() -> void:
	match data.matters.size():
		0:
			%Body.material.shader = load('uid://bdmksfc6m002l')
			%Body.material.set_shader_parameter('base_color', Digest.element_to_color[data.element])
		1:
			%Body.material.shader = load('uid://bq3tymajw0eqn')
			Helper.update_matter_colors(%Body, data.matters)
		2:
			Helper.update_matter_colors(%Body, data.matters)

func update_quotum_matter() -> void:
	var color = Digest.matter_to_color[data.instrument.tribute.current_quotum.shard.matter]
	%Border.get_theme_stylebox("panel").border_color = color

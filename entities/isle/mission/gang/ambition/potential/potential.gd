class_name Potenital
extends TextureRect



var matter_shader = preload('uid://bq3tymajw0eqn')
var element_shader = preload('uid://bdmksfc6m002l')


var data: PotentialData:
	set(value_):
		data = value_
		
		connect_signals()
		update_textures()


#region init
func connect_signals() -> void:
	data.index_changed.connect(_on_index_changed)
	_on_index_changed()
	data.value_changed.connect(_on_value_changed)
	_on_value_changed()

func _on_index_changed() -> void:
	if data.aspect != Bozo.Aspect.NONE:
		position = Vector2(Catalog.aspect_anchors[data.index]) * Catalog.POTENTIAL_SIZE
	else:
		position = Vector2(Catalog.element_anchors[data.index]) * Catalog.POTENTIAL_SIZE


func _on_value_changed() -> void:
	%Body.visible = data.value != 0
	%Value.visible = data.value != 0
	%Border.visible = data.value != 0
	
	%Value.text = str(data.value)

func update_textures() -> void:
	var path: String = 'element'
	%Body.material = ShaderMaterial.new()
	
	if data.aspect != Bozo.Aspect.NONE:
		%Body.material.shader = matter_shader
		path = Bozo.enum_to_string(Bozo.Type.ASPECT, data.aspect)
		var matter = Digest.aspect_to_matter[data.aspect]
		Helper.update_colors(%Body, matter)
		%Body.material.set_shader_parameter('mask_texture', load('res://entities/isle/mission/gang/idea/intention/images/body/%s.png' % path))
	else:
		%Body.material.shader = element_shader
		%Body.material.set_shader_parameter('base_color', Digest.element_to_color[data.element])
	
	%Body.texture = load('res://entities/isle/mission/gang/idea/intention/images/body/%s.png' % path)
	%Border.texture = load('res://entities/isle/mission/gang/idea/intention/images/border/%s.png' % path)
#endregion

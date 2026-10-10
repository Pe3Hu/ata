class_name Structure
extends Node2D


var data: StructureData:
	set(value_):
		data = value_
		
		connect_signals()
		update_spirtes()
		position = Helper.get_structure_position(data)

#var hover_tween: Tween


func connect_signals() -> void:
	data.is_demolished.connect(_on_demolished)

func _on_demolished() -> void:
	get_parent().remove_child(self)
	queue_free()

func update_spirtes() -> void:
	visible = data.type != Bozo.Structure.NONE
	if data.type != Bozo.Structure.SHRINE and data.type != Bozo.Structure.NONE:
		var str_type = Bozo.enum_to_string(Bozo.Type.STRUCTURE, data.type)
		
		if data.type == Bozo.Structure.RUIN:
			str_type += '/%d' % data.order
			var is_flipped = Helper.rng.randf() > 0.5
			%Body.flip_h = is_flipped
			%Border.flip_h = is_flipped
			%Body.material.shader = load('uid://bq3tymajw0eqn')
			Helper.update_matter_colors(%Body, data.matters)
		
		%Body.texture = load('res://entities/continent/mainland/structure/images/%s/body.png' % str_type)
		%Border.texture = load('res://entities/continent/mainland/structure/images/%s/border.png' % str_type)
	
	match data.type:
		Bozo.Structure.RIFT:
			%Body.material.shader = load('uid://cjs2bnp6dr05c')
			%Body.scale *= 1.5
			var speed_factor = Helper.rng.randf_range(0.95, 1.05)
			%Body.material.set_shader_parameter('animation_speed', speed_factor)
			var time_offset = Helper.rng.randf_range(0, 100)
			%Body.material.set_shader_parameter('time_offset', time_offset)
	
	if Catalog.matter_sctructures.has(data.type) or Catalog.single_sctructures.has(data.type):
		var matter = data.cluster.biome.source.matter
		
		if Digest.sctructure_to_matter.has(data.type):
			matter = Digest.sctructure_to_matter[data.type]
	
		%Body.material.shader = load('uid://bq3tymajw0eqn')
		Helper.update_matter_colors(%Body, [matter])
	
	if Catalog.mixed_sctructures.has(data.type):
		%Body.material.shader = load('uid://di23e8ar8ox0t')
		Helper.update_matter_colors(%Body, data.matters)

func _on_area_mouse_entered() -> void:
	Mother.mainland.footprint.target_structure = data
	Mother.mainland.banner.structure = data

func _on_area_mouse_exited() -> void:
	Mother.mainland.footprint.target_structure = null
	Mother.mainland.banner.structure = null

class_name Structure
extends Node2D


var data: StructureData:
	set(value_):
		data = value_
		
		connect_signals()
		update_spirtes()
		position = Helper.get_structure_position(data)

var hover_tween: Tween


func connect_signals() -> void:
	pass

func update_spirtes() -> void:
	if data.type != Bozo.Structure.SHRINE:
		var str_type = Bozo.enum_to_string(Bozo.Type.STRUCTURE, data.type)
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
		Bozo.Structure.RUIN:
			%Body.material.shader = load('uid://bq3tymajw0eqn')
			Helper.update_colors(%Body, data.matter)

func _on_area_mouse_entered() -> void:
	if hover_tween and hover_tween.is_running():
		hover_tween.kill()
	
	hover_tween = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC).set_parallel(true)
	hover_tween.tween_property(self, "scale", Vector2.ONE * 1.1, 0.15)
	data.cluster.mainland.footprint.target_structure = data

func _on_area_mouse_exited() -> void:
	if hover_tween and hover_tween.is_running():
		hover_tween.kill()
	
	hover_tween = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC).set_parallel(true)
	hover_tween.tween_property(self, "scale", Vector2.ONE, 0.15)
	data.cluster.mainland.footprint.target_structure = null

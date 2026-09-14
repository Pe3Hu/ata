class_name Asterism
extends ColorRect


var data: AsterismData:
	set(value_):
		data = value_
		
		connect_signals()
		update_shader()
		update_position()


func connect_signals() -> void:
	data.main_star.current_changed.connect(_on_main_current_chagned)
	_on_main_current_chagned()
	data.secondary_star.current_changed.connect(_on_secondary_current_changed)
	_on_secondary_current_changed()

func _on_main_current_chagned() -> void:
	var mask = (1 << data.main_star.current) - 1
	material.set_shader_parameter("vertex_fill_mask", mask)

func _on_secondary_current_changed() -> void:
	var mask = (1 << data.secondary_star.current) - 1
	material.set_shader_parameter("dash_cross_mask", mask)

func update_position() -> void:
	var n = data.welkin.asterisms.size()
	var index = (n - data.welkin.asterisms.find(data) - 1) % n
	var anchor_angle = TAU / data.welkin.asterisms.size() * index
	offset_transform_position = Vector2.from_angle(anchor_angle - PI / 2) * Catalog.ASTERISM_RAIDUS

func update_shader() -> void:
	material.set_shader_parameter('vertex_circle_count', data.main_star.volume)
	material.set_shader_parameter('dash_count', Digest.asterism_to_amount[data.secondary_star.volume])
	var rotation_speed = Helper.rng.randf_range(-0.15, -0.25)
	material.set_shader_parameter('rotation_speed', rotation_speed)
	
	match data.main_star.volume:
		10:
			material.set_shader_parameter('star_step', 4)
			material.set_shader_parameter('dash_inner', 0.35)
		9:
			material.set_shader_parameter('dash_length', 0.15)
			material.set_shader_parameter('dash_inner', 0.2)
			material.set_shader_parameter('star_step', 3)
			material.set_shader_parameter('dash_cross_glow', 0.004)
			material.set_shader_parameter('dash_glow', 0.004)
		8:
			material.set_shader_parameter('dash_length', 0.18)
			material.set_shader_parameter('dash_inner', 0.3)
			material.set_shader_parameter('star_step', 2)
		7:
			material.set_shader_parameter('dash_length', 0.2)
			material.set_shader_parameter('dash_inner', 0.25)
			material.set_shader_parameter('star_step', 2)
		6:
			material.set_shader_parameter('dash_length', 0.2)
			material.set_shader_parameter('dash_inner', 0.45)#0.26
			material.set_shader_parameter('star_step', 1)#2

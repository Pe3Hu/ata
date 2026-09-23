class_name Obstacle
extends PanelContainer


var data: ObstacleData:
	set(value_):
		data = value_
		
		update_textures()

func update_textures() -> void:
	var type_str = Bozo.enum_to_string(Bozo.Type.OBSTACLE, data.type)
	%ElementBody.texture = load('res://entities/continent/guild/master/guardian/obstacle/images/%s/body.png' % type_str)
	%ElementBorder.texture = load('res://entities/continent/guild/master/guardian/obstacle/images/%s/border.png' % type_str)
	var color = Digest.element_to_color[data.vulnerability]
	%ElementBody.material.set_shader_parameter('base_color', color)
	
	%DifficultyBody.texture = load('res://entities/continent/guild/master/guardian/obstacle/images/complexity/%d/body.png' % data.order_difficulty)
	%DifficultyBorder.texture = load('res://entities/continent/guild/master/guardian/obstacle/images/complexity/%d/border.png' % data.order_difficulty)
	

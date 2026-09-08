class_name Shard
extends PanelContainer


var eddy_data:
	set(value_):
		eddy_data = value_
		
		var index = Digest.element_to_index[eddy_data.element] - 1
		var angle = TAU / 6 * index  
		visible = true
		offset_transform_position = Vector2.from_angle(angle) * Catalog.SHARD_RADIUS #+ Catalog.EDDY_SIZE / 2 
		#offset_transform_rotation = angle
		#value_label.offset_transform_rotation = -angle
		%Background.material.set_shader_parameter('base_color', Digest.element_to_color[eddy_data.element])

@export var value_label: Label

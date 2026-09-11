class_name Shard
extends PanelContainer


var data: ShardData:
	set(value_):
		data = value_
		
		%Amount.text = str(data.amount)
		update_textures()


func update_textures() -> void:
	var matter = Bozo.enum_to_string(Bozo.Type.MATTER, data.matter)
	%Border.texture = load('res://entities/isle/loot/shard/images/border/%s.png' % matter)
	%Body.texture = load('res://entities/isle/loot/shard/images/body/%s.png' % matter)
	%Body.material.set_shader_parameter('mask_texture', load('res://entities/isle/loot/shard/images/body/%s.png' % matter))
	Helper.update_colors(%Body, data.matter)

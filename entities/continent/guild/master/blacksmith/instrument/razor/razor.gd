class_name Razor
extends PanelContainer


var data: RazorData:
	set(value_):
		data = value_
		
		update_texture()
		update_colors()

func update_texture() -> void:
	%Number.frame_coords = Helper.get_coord_based_on_value(data.volume)
	
	if data.matters.size() == 2:
		%Number.position.x = Catalog.STAKE_SIGN_OFFEST
		%Sign.position.x = -Catalog.STAKE_SIGN_OFFEST * 2
		
		if data.volume >= 10:
			%Number.position.x += Catalog.STAKE_SIGN_OFFEST * 0.5
			%Sign.position.x -= Catalog.STAKE_SIGN_OFFEST
	else:
		%Sign.visible = false
		%Body.material.shader = load('uid://bq3tymajw0eqn')

func update_colors() -> void:
	Helper.update_matter_colors(%Body, data.matters)

func update_quotum_matter() -> void:
	var color = Digest.matter_to_color[data.instrument.tribute.current_quotum.shard.matter]
	%Border.get_theme_stylebox("panel").border_color = color

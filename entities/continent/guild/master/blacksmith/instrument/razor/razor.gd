class_name Razor
extends PanelContainer


var data: RazorData:
	set(value_):
		data = value_
		
		update_texture()
		update_matter_colors()

func update_texture() -> void:
	%Number.frame_coords = Helper.get_coord_based_on_value(data.volume)
	
	%Number.position.x = Catalog.STAKE_SIGN_OFFEST
	%Sign.position.x = -Catalog.STAKE_SIGN_OFFEST * 2
	
	if data.volume >= 10:
		%Number.position.x += Catalog.STAKE_SIGN_OFFEST * 0.5
		%Sign.position.x -= Catalog.STAKE_SIGN_OFFEST
			

func update_matter_colors() -> void:
	var matters = data.instrument.blacksmith.guild.structure.matters
	Helper.update_matter_colors(%MatterBG, matters)

func update_quotum_matter() -> void:
	var color = Digest.matter_to_color[data.instrument.tribute.current_quotum.shard.matter]
	%Border.get_theme_stylebox("panel").border_color = color

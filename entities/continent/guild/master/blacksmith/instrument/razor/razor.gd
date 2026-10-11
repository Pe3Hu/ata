class_name Razor
extends PanelContainer


var data: RazorData:
	set(value_):
		data = value_
		
		connect_signals()
		update_colors()



func connect_signals() -> void:
	if not data.volume_changed.is_connected(_on_volue_changed):
		data.volume_changed.connect(_on_volue_changed)
	
	_on_volue_changed()

func _on_volue_changed() -> void:
	%Number.frame_coords = Helper.get_coord_based_on_value(data.volume)
	
	match data.matters.size():
		#0:
			#%Sign.visible = false
			#%Body.material.shader = load('uid://bdmksfc6m002l')
		1:
			%Sign.visible = false
			%Body.material.shader = load('uid://bq3tymajw0eqn')
		2:
			%Number.position.x = Catalog.STAKE_SIGN_OFFEST
			%Sign.position.x = -Catalog.STAKE_SIGN_OFFEST * 2
			
			if data.volume >= 10 and data.volume < 20:
				%Number.position.x += Catalog.STAKE_SIGN_OFFEST * 0.25
				%Sign.position.x -= Catalog.STAKE_SIGN_OFFEST * 0.75
			if data.volume >= 20:
				%Number.position.x += Catalog.STAKE_SIGN_OFFEST * 0.5
				%Sign.position.x -= Catalog.STAKE_SIGN_OFFEST

func update_colors() -> void:
	Helper.update_matter_colors(%Body, data.matters)

#func update_quotum_matter() -> void:
	#var color = Digest.matter_to_color[data.instrument.tribute.current_quotum.shard.matter]
	#%Border.get_theme_stylebox("panel").border_color = color

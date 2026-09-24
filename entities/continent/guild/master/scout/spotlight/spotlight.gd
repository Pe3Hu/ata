class_name Spotlight
extends PanelContainer


var data: SpotlightData:
	set(value_):
		data = value_
		
		connect_signals()

var scout: Scout


func connect_signals() -> void:
	if not data.scout.spotlight_changed.is_connected(_on_spotlight_changed):
		data.scout.spotlight_changed.connect(_on_spotlight_changed)
	
	if not data.tribute.quotum_changed.is_connected(_on_quotum_changed):
		data.tribute.quotum_changed.connect(_on_quotum_changed)
	
	_on_quotum_changed()
	apply_shelter()

func _on_spotlight_changed() -> void:
	data = data.scout.current_spotlight
	_on_quotum_changed()
	apply_shelter()

func apply_shelter() -> void:
	Mother.mainland.beam.update_shelters()
	var camera = scout.guild.mainland.camera
	camera.focus_on_structure(data.shelter.shrine)
	%Index.text = str(data.shelter.index)

#func update_rank_textures() -> void:
	#Helper.update_matter_colors(%Body, [data.tribute.current_quotum.shard.matter])
	#%Border.texture = load('res://entities/continent/guild/master/scout/spotlight/images/%d.png' % data.rank)

func _on_quotum_changed() -> void:
	%Quotum.data = data.tribute.current_quotum
	#update_rank_textures()

#region buttons
func _on_previous_quotum_button_pressed() -> void:
	data.tribute.changed_quotum(-1)

func _on_next_quotum_button_pressed() -> void:
	data.tribute.changed_quotum(1)

func _on_previous_shelter_button_pressed() -> void:
	data.scout.changed_spotlight(-1)

func _on_next_shelter_button_pressed() -> void:
	data.scout.changed_spotlight(1)
#endregion

class_name Spotlight
extends PanelContainer


var data: SpotlightData:
	set(value_):
		data = value_
		
		%Circuit.update_points()
		connect_signals()

var master: Master


func connect_signals() -> void:
	if not data.master.task_changed.is_connected(_on_spotlight_changed):
		data.master.task_changed.connect(_on_spotlight_changed)
	
	if not data.tribute.quotum_changed.is_connected(_on_quotum_changed):
		data.tribute.quotum_changed.connect(_on_quotum_changed)
	
	_on_quotum_changed()
	apply_shelter()

func _on_spotlight_changed() -> void:
	data = data.master.current_task
	_on_quotum_changed()
	apply_shelter()

func apply_shelter() -> void:
	Mother.mainland.beam.update_shelters()
	var camera = master.guild.mainland.camera
	camera.focus_on_structure(data.shelter.shrine)
	%Circuit.marker_shelter = data.shelter

#func update_rank_textures() -> void:
	#Helper.update_matter_colors(%Body, [data.tribute.current_quotum.shard.matter])
	#%Border.texture = load('res://entities/continent/guild/master/master/spotlight/images/%d.png' % data.rank)

func _on_quotum_changed() -> void:
	%Quotum.data = data.tribute.current_quotum
	#update_rank_textures()

#region buttons
func _on_previous_quotum_button_pressed() -> void:
	data.tribute.changed_quotum(-1)

func _on_next_quotum_button_pressed() -> void:
	data.tribute.changed_quotum(1)

func _on_previous_shelter_button_pressed() -> void:
	data.master.changed_task(-1)

func _on_next_shelter_button_pressed() -> void:
	data.master.changed_task(1)
#endregion

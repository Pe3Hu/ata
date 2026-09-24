class_name Firework
extends PanelContainer


var data: FireworkData:
	set(value_):
		data = value_
		
		connect_signals()


func connect_signals() -> void:
	if not data.lightkeeper.firework_changed.is_connected(_on_firework_changed):
		data.lightkeeper.firework_changed.connect(_on_firework_changed)
	
	if not data.tribute.quotum_changed.is_connected(_on_quotum_changed):
		data.tribute.quotum_changed.connect(_on_quotum_changed)
	
	_on_quotum_changed()

func _on_firework_changed() -> void:
	data = data.lightkeeper.current_firework
	_on_quotum_changed()

func update_rank_textures() -> void:
	Helper.update_matter_colors(%Body, [data.tribute.current_quotum.shard.matter])
	%Border.texture = load('res://entities/continent/guild/master/lightkeeper/firework/images/%d.png' % data.rank)

func _on_quotum_changed() -> void:
	%Quotum.data = data.tribute.current_quotum
	update_rank_textures()

#region buttons
func _on_previous_quotum_button_pressed() -> void:
	data.tribute.changed_quotum(-1)

func _on_next_quotum_button_pressed() -> void:
	data.tribute.changed_quotum(1)

func _on_previous_rank_button_pressed() -> void:
	data.lightkeeper.changed_firework(-1)

func _on_next_rank_button_pressed() -> void:
	data.lightkeeper.changed_firework(1)
#endregion

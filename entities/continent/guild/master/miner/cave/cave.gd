class_name Cave
extends PanelContainer


var data: CaveData:
	set(value_):
		data = value_
		
		%Lode.data = data.lode
		connect_signals()


func connect_signals() -> void:
	if not data.master.task_changed.is_connected(_on_cave_changed):
		data.master.task_changed.connect(_on_cave_changed)
	
	if not data.tribute.quotum_changed.is_connected(_on_quotum_changed):
		data.tribute.quotum_changed.connect(_on_quotum_changed)
	
	_on_quotum_changed()

func _on_cave_changed() -> void:
	data = data.master.current_task
	%Lode.data = data.lode
	_on_quotum_changed()

func update_rank_textures() -> void:
	%Avg.text = 'Avg: %d' % Digest.rank_to_avg[data.rank]
	Helper.update_matter_colors(%Body, data.master.guild.structure.matters)
	%Body.texture = load('res://entities/continent/guild/master/miner/cave/images/%d.png' % data.rank)

func _on_quotum_changed() -> void:
	%Quotum.data = data.tribute.current_quotum
	update_rank_textures()

#region buttons
func _on_previous_quotum_button_pressed() -> void:
	data.tribute.changed_quotum(-1)

func _on_next_quotum_button_pressed() -> void:
	data.tribute.changed_quotum(1)

func _on_previous_rank_button_pressed() -> void:
	data.master.changed_task(-1)

func _on_next_rank_button_pressed() -> void:
	data.master.changed_task(1)
#endregion

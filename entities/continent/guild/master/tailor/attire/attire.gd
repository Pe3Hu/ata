class_name Attire
extends PanelContainer


var data: AttireData:
	set(value_):
		data = value_
		
		connect_signals()


#region init
func connect_signals() -> void:
	if not data.master.task_changed.is_connected(_on_changed):
		data.master.task_changed.connect(_on_changed)
	
	if not data.master.current_task.spoil_changed.is_connected(_on_changed):
		data.master.current_task.spoil_changed.connect(_on_changed)
	
	_on_rank_changed()
	_on_spoil_changed()

func _on_changed() -> void:
	data = data.master.current_task
	_on_rank_changed()
	_on_spoil_changed()

func _on_rank_changed() -> void:
	%FirstQuotum.data = data.tributes.front().current_quotum
	%SecondQuotum.data = data.tributes.back().current_quotum
	%Body.texture = load('res://entities/continent/guild/master/tailor/attire/images/%d.png' % data.rank)

func _on_spoil_changed() -> void:
	%Spoil.data = data.current_spoil
	Helper.update_matter_colors(%Body, [data.current_spoil.shard.matter])
#endregion

#region buttons
func _on_previous_matter_button_pressed() -> void:
	data.changed_spoil(-1)

func _on_next_matter_button_pressed() -> void:
	data.changed_spoil(-1)

func _on_previous_rank_button_pressed() -> void:
	data.master.changed_task(-1)

func _on_next_rank_button_pressed() -> void:
	data.master.changed_task(1)
#endregion

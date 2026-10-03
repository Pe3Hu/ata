class_name Task
extends PanelContainer


var data: TaskData:
	set(value_):
		data = value_
		
		connect_signals()

func connect_signals() -> void:
	if not data.master.task_changed.is_connected(_on_task_changed):
		data.master.task_changed.connect(_on_task_changed)
	
	if not data.tributes.is_empty():
		for tribute in data.tributes:
			if not tribute.quotum_changed.is_connected(_on_quotum_changed):
				tribute.quotum_changed.connect(_on_quotum_changed)
		
		_on_quotum_changed()
	
	update_order_textures()

func _on_task_changed() -> void:
	data = data.master.current_task
	_on_quotum_changed()

func _on_quotum_changed() -> void:
	%Quotum.data = data.tributes.front().current_quotum
	update_order_textures()
	update_colors()

func update_order_textures() -> void:
	if Catalog.noicon_masters.has(data.master.type): return
	var matters: Array
	
	match data.master.type:
		Bozo.Master.TAILOR:
			matters = [data.current_spoil.shard.matter]
		Bozo.Master.MINER:
			matters = [data.lode.matter]
	
	if matters.is_empty():
		matters = [data.tributes.front().current_quotum.shard.matter]
	
	Helper.update_matter_colors(%OrderBody, matters)
	var master_str = Bozo.enum_to_string(Bozo.Type.MASTER, data.master.type)
	var task_str = Digest.master_to_task[data.master.type]
	%OrderBody.texture = load('res://entities/continent/guild/master/%s/%s/images/%d/body.png' % [master_str, task_str, data.order])
	%OrderBorder.texture = load('res://entities/continent/guild/master/%s/%s/images/%d/border.png' % [master_str, task_str, data.order])

func update_colors() -> void:
	pass

#region buttons
func _on_previous_quotum_button_pressed() -> void:
	data.tributes.front().changed_quotum(-1)

func _on_next_quotum_button_pressed() -> void:
	data.tributes.front().changed_quotum(1)

func _on_previous_order_button_pressed() -> void:
	data.master.changed_task(-1)

func _on_next_order_button_pressed() -> void:
	data.master.changed_task(1)
#endregion

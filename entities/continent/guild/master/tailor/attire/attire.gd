class_name Attire
extends Task


#region init
func connect_signals() -> void:
	super.connect_signals()
	
	if not data.master.current_task.spoil_changed.is_connected(_on_task_changed):
		data.master.current_task.spoil_changed.connect(_on_task_changed)
	
	_on_order_changed()
	_on_spoil_changed()
	update_order_textures()

func _on_task_changed() -> void:
	data = data.master.current_task
	_on_order_changed()
	_on_spoil_changed()
	update_order_textures()

func _on_order_changed() -> void:
	%FirstQuotum.data = data.tributes.front().current_quotum
	%SecondQuotum.data = data.tributes.back().current_quotum

func _on_spoil_changed() -> void:
	%Spoil.data = data.current_spoil
	Helper.update_matter_colors(%OrderBody, [data.current_spoil.shard.matter])
#endregion

#region buttons
func _on_previous_matter_button_pressed() -> void:
	data.changed_spoil(-1)

func _on_next_matter_button_pressed() -> void:
	data.changed_spoil(-1)
#endregion

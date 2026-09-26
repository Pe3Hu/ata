class_name Veteran
extends Recruit




func connect_signals() -> void:
	if not data.musician.task_changed.is_connected(_on_veteran_changed):
		data.musician.task_changed.connect(_on_veteran_changed)
	
	if not data.tribute.quotum_changed.is_connected(_on_quotum_changed):
		data.tribute.quotum_changed.connect(_on_quotum_changed)
	
	_on_quotum_changed()

func _on_veteran_changed() -> void:
	data = data.musician.current_task
	_on_quotum_changed()

func _on_previous_recruit_button_pressed() -> void:
	data.musician.changed_task(-1)

func _on_next_recruit_button_pressed() -> void:
	data.musician.changed_task(1)

class_name Architect
extends Master



func _ready() -> void:
	data = Mother.guild.architect
	super._ready()

func connect_signals() -> void:
	data.task_changed.connect(_on_asterism_changed)
	_on_asterism_changed()
	data.current_task.main_star.current_changed.connect(_on_main_star_changed)
	_on_main_star_changed()
	data.current_task.secondary_star.current_changed.connect(_on_secondary_star_changed)
	_on_secondary_star_changed()

func _on_asterism_changed() -> void:
	%Asterism.data = data.current_task
	%Asterism.offset_transform_position = Vector2()
	_on_main_star_changed()
	_on_secondary_star_changed()

func _on_main_star_changed() -> void:
	var amount = '\nAmount: %d/%d' % [data.current_task.main_star.current, data.current_task.main_star.limit]
	var volume = '\nVolume: %d' % data.current_task.main_star.volume
	%MainStar.text = 'Big Stars' + volume + amount

func _on_secondary_star_changed() -> void:
	if data.current_task.secondary_star.limit > 0:
		var amount = '\nAmount: %d/%d' % [data.current_task.secondary_star.current, data.current_task.secondary_star.limit]
		var volume = '\nVolume: %d' % data.current_task.secondary_star.volume
		%SecondaryStar.text = 'Small Stars' + volume + amount
	else:
		%SecondaryStar.text = ''

func _on_previous_button_pressed() -> void:
	data.changed_task(-1)

func _on_next_button_pressed() -> void:
	data.changed_task(1)

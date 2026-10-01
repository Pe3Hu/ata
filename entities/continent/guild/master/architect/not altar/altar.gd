class_name NotAltar
extends Task


func connect_signals() -> void:
	super.connect_signals()
	if not data.asterism.external_star.current_changed.is_connected(_on_external_star_changed):
		data.asterism.external_star.current_changed.connect(_on_external_star_changed)
	
	if not data.asterism.internal_star.current_changed.is_connected(_on_internal_star_changed):
		data.asterism.internal_star.current_changed.connect(_on_internal_star_changed)
	
	_on_external_star_changed()
	_on_internal_star_changed()

func _on_task_changed() -> void:
	data = data.master.current_task
	%Asterism.data = data.asterism
	%Asterism.offset_transform_position = Vector2()
	_on_external_star_changed()
	_on_internal_star_changed()

func _on_external_star_changed() -> void:
	%ExternalVolume.text = '%d' % data.asterism.external_star.volume
	%ExternalAmount.text = '%d/%d' % [data.asterism.external_star.current, data.asterism.external_star.limit]

func _on_internal_star_changed() -> void:
	%InternalVBox.visible = data.asterism.internal_star.limit > 0
	
	if data.asterism.internal_star.limit > 0:
		%InternalVolume.text = '%d' % data.asterism.internal_star.volume
		%InternalAmount.text = '%d/%d' % [data.asterism.internal_star.current, data.asterism.internal_star.limit]
	

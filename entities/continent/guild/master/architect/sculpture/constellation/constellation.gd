class_name Constellation
extends PanelContainer


const prepared_texture = preload('uid://dmb7tyyhcdpg7')
const unprepared_texture = preload('uid://bd5clrttadkq0')


var asterism: AsterismData:
	set(value_):
		asterism = value_
		
		connect_signals()


func _ready() -> void:
	var matters = [Bozo.Matter.SOLID]
	Helper.update_matter_colors(%ExternalBody, matters)
	Helper.update_matter_colors(%InternalBody, matters)
	Helper.update_matter_colors(%StatusBody, matters)

func connect_signals() -> void:
	if not asterism.external_star.current_changed.is_connected(_on_external_star_changed):
		asterism.external_star.current_changed.connect(_on_external_star_changed)
	
	if not asterism.internal_star.current_changed.is_connected(_on_internal_star_changed):
		asterism.internal_star.current_changed.connect(_on_internal_star_changed)
		
	_on_external_star_changed()
	_on_internal_star_changed()

func _on_external_star_changed() -> void:
	%ExternalVolume.text = '%d' % asterism.external_star.volume
	%ExternalAmount.text = '%d/%d' % [asterism.external_star.current, asterism.external_star.limit]
	%ExternalBody.visible = asterism.external_star.current >= asterism.external_star.limit
	_on_status_star_changed()

func _on_internal_star_changed() -> void:
	%InternalVBox.visible = asterism.internal_star.limit > 0
	
	if asterism.internal_star.limit > 0:
		%InternalVolume.text = '%d' % asterism.internal_star.volume
		%InternalAmount.text = '%d/%d' % [asterism.internal_star.current, asterism.internal_star.limit]
		%InternalBody.visible = asterism.internal_star.current >= asterism.internal_star.limit
	else:
		%InternalBody.visible = %ExternalBody.visible
	
	_on_status_star_changed()

func _on_status_star_changed() -> void:
	%StatusBody.visible = asterism.is_prepared()
	
	if %StatusBody.visible:
		%StatusBorder.texture = prepared_texture
	else:
		%StatusBorder.texture = unprepared_texture

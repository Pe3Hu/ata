class_name Pressure
extends PanelContainer


var data: PressureData:
	set(value_):
		data = value_
		
		connect_signals()


func connect_signals() -> void:
	data.element_changed.connect(_on_element_changed)
	_on_element_changed()
	data.amount_changed.connect(_on_amount_changed)
	_on_amount_changed()

func _on_amount_changed() -> void:
	%Amount.text = str(data.amount)
	%Amount.visible = data.amount > 1

func _on_element_changed() -> void:
	%Body.material.set_shader_parameter('base_color', Digest.element_to_color[data.element])

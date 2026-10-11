class_name Gloom
extends PanelContainer


@export var elite: Elite

var data: GloomData:
	set(value_):
		data = value_
		
		connect_signals()
		%Body.material.set_shader_parameter('base_color', Digest.element_to_color[data.element])

var sync_tween: Tween


func connect_signals() -> void:
	if not Mother.nightmare.admit_defeat.is_connected(_on_defeat):
		Mother.nightmare.admit_defeat.connect(_on_defeat)
	
	if not data.value_changed.is_connected(_on_value_changed):
		data.value_changed.connect(_on_value_changed)
	
	_on_value_changed()

func _on_value_changed() -> void:
	%Value.text = str(data.current_value)
	%LeaveButton.visible = data.current_value <= 0

func _on_defeat() -> void:
	%AbandonButton.visible = true

func sync_values() -> void:
	if data.current_value == data.next_value: return
	var duration = Gear.glooms[Gear.tempo]
	sync_tween = create_tween().set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_SPRING).set_parallel(true)
	sync_tween.tween_property(data, "current_value", data.next_value, duration)

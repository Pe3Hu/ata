@tool
class_name Canto
extends PanelContainer


var data: CantoData:
	set(value_):
		data = value_
		
		connect_signals()
		connect_datas()

var hymn: Hymn

@export var pulse: Pulse

@export var intro: Tune
@export var verse: Tune
@export var outro: Tune



#region init
func connect_signals() -> void:
	data.is_critical_changed.connect(pulse._on_is_critical_changed)
	pulse._on_is_critical_changed()
	data.is_selected_changed.connect(_on_is_selected_changed)
	_on_is_selected_changed()
	data.voice.connect(_on_voice)

func connect_datas() -> void:
	pulse.value = data.pulse_value
	intro.data = data.intro
	
	if data.verse:
		verse.data = data.verse
	
	if data.outro:
		outro.data = data.outro
		pulse.icon.offset_transform_rotation = PI / 2

func _on_is_selected_changed() -> void:
	var bg_color: Color = Digest.canto_to_selection[data.is_selected]
	pulse.icon.material.set_shader_parameter("bg_color", bg_color)

func _on_voice() -> void:
	var is_last = get_parent().get_child_count() == 1
	get_parent().remove_child(self)
	queue_free()
	
	if is_last:
		hymn.get_parent().remove_child(hymn)
		hymn.queue_free()
	
	if hymn.active_canto_index > 0:
		hymn.active_canto_index -= 1
	else:
		hymn.active_canto_index = 0
#endregion

#region selection
func _on_button_pressed() -> void:
	update_selection()

func update_selection() -> void:
	if hymn.odeum.data.current_canto == data: return
	
	if data.hymn.scenario.room == Bozo.Room.KITCHEN:
		hymn.odeum.data.current_canto = data
		data.is_selected = true
#endregion

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
		verse.visible = true
	else:
		verse.visible = false
	
	if data.outro:
		outro.data = data.outro
		outro.visible = true
	else:
		outro.visible = false

func _on_is_selected_changed() -> void:
	match data.is_selected:
		true:
			%Selection.color = Color.LIGHT_GRAY
		false:
			%Selection.color = Color.WEB_GRAY

func _on_voice() -> void:
	hymn.get_parent().remove_child(hymn)
	hymn.queue_free()
	queue_free()
#endregion

func _on_button_pressed() -> void:
	update_selection()

func update_selection() -> void:
	if hymn.odeum.data.current_canto == data: return
	hymn.odeum.data.current_canto = data
	data.is_selected = true

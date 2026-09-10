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
	data.is_perfect_changed.connect(pulse._on_is_perfect_changed)
	pulse._on_is_perfect_changed()
	
	data.pulse_changed.connect(pulse._on_value_changed)
	pulse._on_value_changed()
	
	data.is_selected_changed.connect(pulse._on_is_selected_changed)
	pulse._on_is_selected_changed()
	
	data.voice_up.connect(_on_voice_up)

func connect_datas() -> void:
	intro.data = data.intro
	
	if data.verse:
		verse.data = data.verse
	
	if data.outro:
		outro.data = data.outro
		pulse.get_node('%Body').offset_transform_rotation = PI / 2

func _on_voice_up() -> void:
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

func update_selection() -> void:
	if hymn.odeum.data.current_canto == data: return
	
	if data.hymn.scenario.room == Bozo.Room.KITCHEN:
		hymn.odeum.data.current_canto = data
		data.is_selected = true

class_name Route
extends PanelContainer


var data: RouteData:
	set(value_):
		data = value_
		
		connect_signals()


func _ready() -> void:
	data = Mother.mainland.route

func connect_signals() -> void:
	data.selected_type_changed.connect(_on_selected_type_changed)
	_on_selected_type_changed()

func _on_selected_type_changed() -> void:
	var travel_time = data.get_travel_time()
	%TravelTime.text = 'Travel time: %d' % travel_time

func _input(event) -> void:
	if event is InputEventKey and event.pressed and not event.echo:
		match event.keycode:
			KEY_Q:
				data.change_selected_type(1)
			KEY_W:
				data.change_selected_type(-1)

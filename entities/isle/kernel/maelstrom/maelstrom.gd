class_name Maelstrom
extends PanelContainer


var eddy_scene = preload("uid://ygvrqdry5mbm")

var data: MaelstromData:
	set(value_):
		data = value_
		
		init_eddies()
		connect_signals()



func connect_signals() -> void:
	data.eddy_focused.connect(_on_eddy_focused)

func _on_eddy_focused() -> void:
	for eddy in %Eddies.get_children():
		if data.focused_eddy == null:
			eddy.visible = true
		else:
			eddy.visible = eddy.data == data.focused_eddy

func init_eddies() -> void:
	%Eddies.offset_transform_position = -Catalog.EDDY_SIZE / 2
	
	for eddy_data in data.eddies:
		add_eddy(eddy_data)

func add_eddy(eddy_data_: EddyData) -> void:
	var eddy = eddy_scene.instantiate()
	%Eddies.add_child(eddy)
	eddy.data = eddy_data_

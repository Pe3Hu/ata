class_name Maelstrom
extends PanelContainer


var eddy_scene = preload("uid://ygvrqdry5mbm")

var data: MaelstromData:
	set(value_):
		data = value_
		
		init_eddies()


func init_eddies() -> void:
	%Eddies.offset_transform_position = -Catalog.EDDY_SIZE / 2
	
	for eddy_data in data.eddies:
		add_eddy(eddy_data)

func add_eddy(eddy_data_: EddyData) -> void:
	var eddy = eddy_scene.instantiate()
	%Eddies.add_child(eddy)
	eddy.data = eddy_data_

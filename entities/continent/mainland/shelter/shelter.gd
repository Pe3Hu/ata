class_name Shelter
extends Node2D


var data: ShelterData:
	set(value_):
		data = value_
		
		connect_datas()
		position = Helper.get_cluster_position(data)


func connect_datas() -> void:
	%Shrine.data = data.shrine

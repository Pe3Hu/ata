class_name Lode
extends Node2D


var vein_scene = preload("uid://b3an2uynv7uwp")

var data: LodeData:
	set(value_):
		data = value_
		
		init_veins()




func _ready() -> void:
	position = get_parent().size / 2

func init_veins() -> void:
	Helper.clear_children(%Veins)

	for vein_data in data.veins:
		add_vein(vein_data)

func add_vein(vein_data_: VeinData) -> void:
	var vein = vein_scene.instantiate()
	%Veins.add_child(vein)
	vein.lode = self
	vein.data = vein_data_

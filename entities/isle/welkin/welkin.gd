class_name Welkin
extends Control


var asterism_scene = preload("uid://7422stye5c3g")

var data: WelkinData:
	set(value_):
		data = value_
		
		init_asterisms()


func init_asterisms() -> void:
	for asterim_data in data.asterisms:
		add_asterism(asterim_data)

func add_asterism(asterism_data_: AsterismData) -> void:
	var asterism = asterism_scene.instantiate()
	%Astersims.add_child(asterism)
	asterism.data = asterism_data_

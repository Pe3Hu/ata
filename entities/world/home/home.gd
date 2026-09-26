class_name Home 
extends Control


@export var isle_scene = preload("uid://b4uxyqcdfn3uo")
@export var continent_scene = preload("uid://cxf2drfp6ytg6")#preload("uid://1vg6bjn7l21t")



func _ready() -> void:
	if Arbitrator.is_gameover:
		await get_tree().process_frame
		_on_continent_button_pressed()

func _on_isle_button_pressed() -> void:
	get_tree().change_scene_to_packed(isle_scene)

func _on_continent_button_pressed() -> void:
	get_tree().change_scene_to_packed(continent_scene)

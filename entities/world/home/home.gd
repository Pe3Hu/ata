class_name Home 
extends Control


@export var isle_scene = preload("uid://b4uxyqcdfn3uo")
@export var continent_scene = preload("uid://cxf2drfp6ytg6")#preload("uid://1vg6bjn7l21t")
@export var depredation_scene = preload("uid://dklrx1v4ittfx")
@export var nightmare_scene = preload("uid://by50xo16jdi5b")


func _ready() -> void:
	if Arbitrator.is_gameover:
		await get_tree().process_frame
		_on_nightmare_button_pressed()
		#_on_continent_button_pressed()
		#_on_depredation_button_pressed()

func _on_isle_button_pressed() -> void:
	get_tree().change_scene_to_packed(isle_scene)

func _on_continent_button_pressed() -> void:
	get_tree().change_scene_to_packed(continent_scene)

func _on_depredation_button_pressed() -> void:
	var ruins = []
	for wasteland in Mother.mainland.wastelands:
		for structure in wasteland.structures:
			if structure.type == Bozo.Structure.RUIN and structure.order == 0:
				ruins.append(structure)
				break
		
		if not ruins.is_empty():
			break
	
	Mother.guild.structure = ruins.pick_random()
	Mother.depredation.bank.ruin = Mother.guild.structure
	#await get_tree().create_timer(0.1).timeout
	get_tree().change_scene_to_packed(depredation_scene)

func _on_nightmare_button_pressed() -> void:
	var rifts = []
	for wasteland in Mother.mainland.wastelands:
		for structure in wasteland.structures:
			if structure.type == Bozo.Structure.RIFT and structure.order == 0:
				rifts.append(structure)
				break
		
		if not rifts.is_empty():
			break
	
	Mother.guild.structure = rifts.pick_random()
	#Mother.nightmare.rift = Mother.guild.structure
	Mother.nightmare.test_update_attic()
	#await get_tree().create_timer(0.1).timeout
	get_tree().change_scene_to_packed(nightmare_scene)

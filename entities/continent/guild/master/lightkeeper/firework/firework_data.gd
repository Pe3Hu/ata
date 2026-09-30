class_name FireworkData
extends TaskData


var tinted_shelters: Array[ShelterData]


func _on_finished() -> void:
	light_up()
	super._on_finished()

func get_tinted_shelters() -> Array:
	var shelter_to_fog: Dictionary
	
	for shelter in Mother.guild.scout.internals:
		shelter_to_fog[shelter] = shelter.count_total_fog_pixels()
	
	var shelters = Mother.guild.scout.internals.duplicate()
	shelters.sort_custom(func (a, b): return shelter_to_fog[a] > shelter_to_fog[b])
	shelters.resize(rank + 1)
	return shelters

func light_up() -> void:
	for shelter in tinted_shelters:
		Mother.mainland.haze.reveal_shelter_wave(shelter.index)

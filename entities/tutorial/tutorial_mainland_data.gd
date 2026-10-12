class_name TutorialMainlandData
extends MainlandData


func _init() -> void:
	init_shelters_and_wastelands()
	remove_nontutorial_wastelands()
	update_coord_to_cluster()
	init_neighbors()
	remove_nontutorial_shelters()
	update_coord_to_cluster()
	clear_neighbors()
	init_neighbors()
	init_biomes()
	init_structures()
	#init_magistrals()
	#init_trods()
	#update_start_structure()

func remove_nontutorial_wastelands() -> void:
	for _i in range(wastelands.size()-1, -1, -1):
		var wasteland = wastelands[_i]
		if not Tutorial.wasteland_indexs.has(wasteland.index):
			remove_wasteland(wasteland)

func remove_wasteland(wasteland_: WastelandData) -> void:
	wastelands.erase(wasteland_)
	var clusters: Array = terrain_to_clusters[wasteland_.terrain]
	clusters.erase(wasteland_)
	
	if clusters.is_empty():
		terrain_to_clusters.erase(wasteland_.terrain)

func remove_nontutorial_shelters() -> void:
	for _i in range(shelters.size()-1, -1, -1):
		var shelter = shelters[_i]
		var has_tutorial_wasteland = false
		
		for wasteland in shelter.neighbor_wastelands:
			if Tutorial.wasteland_indexs.has(wasteland.index):
				has_tutorial_wasteland = true
				break
		
		if not has_tutorial_wasteland:
			remove_shelter(shelter)

func remove_shelter(shelter_: ShelterData) -> void:
	shelters.erase(shelter_)
	var clusters: Array = terrain_to_clusters[shelter_.terrain]
	clusters.erase(shelter_)
	
	if clusters.is_empty():
		terrain_to_clusters.erase(shelter_.terrain)

func clear_neighbors() -> void:
	for wasteland in wastelands:
		wasteland.neighbor_wastelands.clear()
		wasteland.neighbor_shelters.clear()
	
	for shelter in shelters:
		shelter.neighbor_wastelands.clear()
		shelter.neighbor_shelters.clear()

func init_biomes() -> void:
	var type = Bozo.Biome.MOUNTAIN
	biomes.clear()
	var biome = BiomeData.new(type, wastelands)
	biomes.append(biome)

func init_structures() -> void:
	for wasteland in wastelands:
		for structure_type in Tutorial.index_to_structures[wasteland.index]:
			wasteland.add_structure(structure_type, -Vector2i.ONE, -1, true)
		
		var coords = wasteland.coord_options.duplicate()
		
		for coord in coords:
			wasteland.add_structure(Bozo.Structure.RUIN, coord, 0, true)

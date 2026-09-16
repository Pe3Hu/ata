class_name ShelterData
extends CluserData



func _init(maindland_: MainlandData, anchor_: Vector2i, terrain_: Bozo.Terrain) -> void:
	super._init(maindland_, anchor_, terrain_)
	
	if internals.size() == Digest.terrain_to_cluster_size[terrain] * Digest.terrain_to_cluster_size[terrain]:
		mainland.shelters.append(self)
		init_externals()
		
		if not mainland.terrain_to_clusters.has(terrain):
			mainland.terrain_to_clusters[terrain] = []
		
		mainland.terrain_to_clusters[terrain].append(self)

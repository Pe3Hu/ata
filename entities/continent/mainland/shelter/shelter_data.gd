class_name ShelterData
extends ClusterData



var shrine: ShrineData = ShrineData.new(self, Bozo.Structure.SHRINE)


func _init(maindland_: MainlandData, anchor_: Vector2i, terrain_: Bozo.Terrain) -> void:
	super._init(maindland_, anchor_, terrain_)
	
	if internals.size() == Digest.terrain_to_cluster_size[terrain] * Digest.terrain_to_cluster_size[terrain]:
		index = mainland.shelters.size()
		mainland.shelters.append(self)
		init_externals()
		
		if not mainland.terrain_to_clusters.has(terrain):
			mainland.terrain_to_clusters[terrain] = []
		
		mainland.terrain_to_clusters[terrain].append(self)

func link_shelter_neighbors() -> void:
	var shift = Digest.terrain_to_col_shift[terrain]
	var shifts = [
		Vector2i(shift.x, shift.y),
		Vector2i(-shift.y, shift.x),
		Vector2i(-shift.x, -shift.y),
		Vector2i(shift.y, -shift.x),
	]
	
	for _shift in shifts:
		var neighbor_cell = internals.front() + _shift
		
		if mainland.cell_to_cluster.has(neighbor_cell):
			var neighbor_shelter = mainland.cell_to_cluster[neighbor_cell]
			neighbor_shelters.append(neighbor_shelter)

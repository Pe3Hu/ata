class_name RiftData
extends StructureData


var current_gloom: int
var limit_gloom: int


func _init(cluster_: ClusterData, type_: Bozo.Structure, coord_: Vector2i = Vector2i.ZERO) -> void:
	super._init(cluster_, type_, coord_)
	roll_gloom()

func roll_gloom() -> void:
	limit_gloom = 10
	current_gloom = int(limit_gloom)

func restore_trods(old_structure_: StructureData) -> void:
	trod_to_structure = old_structure_.trod_to_structure.duplicate()
	
	for trod: TrodData in trod_to_structure:
		var neighbor: StructureData = trod_to_structure[trod]
		neighbor.trod_to_structure[trod] = self
		
		var index := trod.structures.find(old_structure_)
		if index != -1:
			trod.structures[index] = self
	
	old_structure_.trod_to_structure.clear()
	
	var wasteland := cluster as WastelandData
	var slot := wasteland.structures.find(old_structure_)
	if slot != -1:
		wasteland.structures[slot] = self
	
	wasteland.coord_to_structure[coord] = self
	wasteland.type_to_structure[type] = self
	wasteland.type_to_coord[type] = coord
	
	var stale_types: Array = []
	for structure_type in wasteland.type_to_structure:
		if structure_type != type and wasteland.type_to_structure[structure_type] == old_structure_:
			stale_types.append(structure_type)
	
	for structure_type in stale_types:
		wasteland.type_to_structure.erase(structure_type)
		wasteland.type_to_coord.erase(structure_type)

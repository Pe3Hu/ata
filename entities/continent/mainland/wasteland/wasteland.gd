class_name Wasteland
extends Node2D


var structure_scene = preload('uid://ctxs2sl7jnlkw')

var data: WastelandData:
	set(value_):
		data = value_
		
		init_structures()
		position = Helper.get_cluster_position(data)


#region init
func init_structures() -> void:
	for structure_data in data.structures:
		add_structure(structure_data)

func add_structure(structure_data_: StructureData) -> void:
	var structure = structure_scene.instantiate()
	%Structures.add_child(structure)
	structure.data = structure_data_
#endregion

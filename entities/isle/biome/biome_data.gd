class_name BiomeData
extends RefCounted


var type: Bozo.Biome
var wastelands: Array[WastelandData]

var source: SourceData


func _init(type_: Bozo.Biome, wastelands_: Array) -> void:
	type = type_
	wastelands.append_array(wastelands_)
	
	source = load('res://entities/isle/biome/source/%s.tres' % Bozo.enum_to_string(Bozo.Type.BIOME, type))
	
	for wasteland in wastelands:
		wasteland.biome = self

func add_structure(structure_type_: Bozo.Structure) -> void:
	wastelands.sort_custom(func (a, b): return a.cells_options.size() > b.cells_options.size())
	var options = wastelands.filter(func (a): return wastelands.front().cells_options.size() == a.cells_options.size())
	options = options.filter(func (a): return not Helper.wasteland_already_has_neighbor_structure(a, structure_type_))
	
	if options.is_empty():
		options = wastelands.filter(func (a): return wastelands.front().cells_options.size() == a.cells_options.size())
	
	var wasteland = options.pick_random()
	wasteland.add_structure(structure_type_)

func is_empty() -> bool:
	for wasteland in wastelands:
		if wasteland.structures.is_empty():
			return true
	
	return false

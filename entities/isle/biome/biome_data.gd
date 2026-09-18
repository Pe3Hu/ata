class_name BiomeData
extends RefCounted


var type: Bozo.Biome
var wastelands: Array[WastelandData]

var source: SourceData


#region init
func _init(type_: Bozo.Biome, wastelands_: Array) -> void:
	type = type_
	wastelands.append_array(wastelands_)
	
	for wasteland in wastelands:
		wasteland.biome = self

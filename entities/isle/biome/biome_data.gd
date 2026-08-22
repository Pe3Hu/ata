class_name BiomeData
extends RefCounted


var type: Bozo.Biome

var source: SourceData


#region init
func _init(type_: Bozo.Biome = Bozo.Biome.NONE) -> void:
	type = type_
	

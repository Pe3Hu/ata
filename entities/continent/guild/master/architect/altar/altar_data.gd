class_name AltarData
extends RefCounted


var structure: StructureData


func _init(structure_: StructureData) -> void:
	structure = structure_
	Mother.guild.architect.altars.append(self)

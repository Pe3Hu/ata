class_name BannerData
extends RefCounted


signal structure_changed

var mainland: MainlandData
var structure: StructureData:
	set(value_):
		structure = value_
		structure_changed.emit()


func _init(mainland_: MainlandData) -> void:
	mainland = mainland_

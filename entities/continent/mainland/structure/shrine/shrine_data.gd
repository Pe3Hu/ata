class_name ShrineData
extends StructureData


signal illuminate_changed
signal haze_changed

var is_hazed: bool = true:
	set(value_):
		is_hazed = value_
		haze_changed.emit()
var is_illuminated: bool = false:
	set(value_):
		is_illuminated = value_
		illuminate_changed.emit()

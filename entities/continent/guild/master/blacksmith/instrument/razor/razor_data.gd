class_name RazorData
extends RefCounted


var instrument: InstrumentData
var volume: int


func _init(instrument_: InstrumentData, volume_: int) -> void:
	instrument = instrument_
	volume = volume_
	
	instrument.razors.append(self)

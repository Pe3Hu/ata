class_name FluxData
extends RefCounted


signal volume_changed

var eddy: EddyData
var stepladder: StepladderData

var volume: int = 2:
	set(value_):
		volume = value_
		volume_changed.emit()
		
		if stepladder:
			stepladder.volume_changed.emit()


func _init(eddy_: EddyData) -> void:
	eddy = eddy_

func promote_volume(matter_: Bozo.Matter) -> void:
	volume = Digest.volume_to_matter_to_volume[volume][matter_]

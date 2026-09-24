class_name VeinData
extends RefCounted


var lode: LodeData
var volume: int
var percent: int

var start_angle: float = 0


func _init(lode_: LodeData, volume_: int, percent_: int) -> void:
	lode = lode_
	volume = volume_
	percent = percent_
	
	for vein in lode.veins:
		start_angle += vein.percent
	
	start_angle *= TAU / 100
	lode.veins.append(self)

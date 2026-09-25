class_name WelkinData
extends RefCounted


var volume_to_asterism: Dictionary
var asterisms: Array


func _init() -> void:
	init_asterisms()

func init_asterisms() -> void:
	for main_volume in Digest.main_to_secondary:
		var _asterism = AsterismData.new(self, main_volume)

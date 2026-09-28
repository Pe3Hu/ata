class_name WelkinData
extends RefCounted


var volume_to_asterism: Dictionary
var asterisms: Array


func _init() -> void:
	init_asterisms()

func init_asterisms() -> void:
	for external_volume in Digest.external_to_internal:
		AsterismData.new(self, external_volume)

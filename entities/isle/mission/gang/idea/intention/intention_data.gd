class_name IntentionData
extends Resource


@export var element: Bozo.Element
@export var aspect: Bozo.Aspect

var value: int = 1


func _init(original_: IntentionData) -> void:
	element = original_.element
	aspect = original_.aspect

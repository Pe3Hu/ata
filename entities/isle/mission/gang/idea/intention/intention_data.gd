class_name IntentionData
extends Resource


@export var element: Bozo.Element
@export var aspect: Bozo.Aspect

var value: int = 1


func _init(original_: IntentionData = null) -> void:
	if original_:
		element = original_.element
		aspect = original_.aspect

class_name IntentionData
extends Resource


signal bond_changed

@export var element: Bozo.Element
@export var aspect: Bozo.Aspect

var value: int = 1
var is_bond: bool = false:
	set(value_):
		is_bond = value_
		bond_changed.emit()


func _init(original_: IntentionData = null) -> void:
	if original_:
		element = original_.element
		aspect = original_.aspect

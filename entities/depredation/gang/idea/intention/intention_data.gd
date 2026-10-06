class_name IntentionData
extends Resource


signal bond_changed

@export var element: Bozo.Element
@export var aspect: Bozo.Aspect
var idea: IdeaData

var value: int = 1
var is_bond: bool = false:
	set(value_):
		is_bond = value_
		bond_changed.emit()


func _init(original_: IntentionData = null) -> void:
	if original_:
		element = original_.element
		aspect = original_.aspect

func update_impulses(attempt_: AttemptData) -> void:
	for method_type in Digest.aspect_to_method_to_factor[aspect]:
		var factor = Digest.aspect_to_method_to_factor[aspect][method_type]
		var impulse = attempt_.method_to_impulse[method_type]
		impulse.value += value * factor
	
	var element_method_type: Bozo.Method
	
	if element != Bozo.Element.CHAOS:
		element_method_type = Digest.element_to_method[element]
	#else:
		#var options = Catalog.elements.duplicate()
		#options.erase(element)
		#element_method_type = Digest.element_to_method[options.pick_random()]
	
		var element_impulse = attempt_.method_to_impulse[element_method_type]
		element_impulse.value += value * Catalog.ELEMENT_IMPULSE_FACTOR

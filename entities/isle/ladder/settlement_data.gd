class_name SettlementData
extends RefCounted


var stepladder: StepladderData



func _init() -> void:
	stepladder = StepladderData.new(self)

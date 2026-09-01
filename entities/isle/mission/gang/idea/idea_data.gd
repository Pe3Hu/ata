class_name IdeaData
extends RefCounted


var intentions: Array[IntentionData]


func _init(index_: int) -> void:
	var opportinity = load("res://entities/isle/mission/gang/idea/opportunity/%d.tres" % index_)
	
	for original_intention in opportinity.intentions:
		var intention = IntentionData.new(original_intention)
		intentions.append(intention)

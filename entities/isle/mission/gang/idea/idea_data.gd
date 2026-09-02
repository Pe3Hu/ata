class_name IdeaData
extends RefCounted


signal active_changed

var gang: GangData
var intentions: Array[IntentionData]

var is_active: bool = false:
	set(value_):
		is_active = value_
		active_changed.emit()


func _init(gang_: GangData, index_: int) -> void:
	gang = gang_
	gang.ideas.append(self)
	
	var opportinity = load("res://entities/isle/mission/gang/idea/opportunity/%d.tres" % index_)
	
	for original_intention in opportinity.intentions:
		var intention = IntentionData.new(original_intention)
		intentions.append(intention)

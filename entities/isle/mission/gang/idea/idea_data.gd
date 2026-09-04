class_name IdeaData
extends RefCounted


signal active_changed
signal bond_changed

var gang: GangData
var intentions: Array[IntentionData]

var is_active: bool = false:
	set(value_):
		is_active = value_
		active_changed.emit()
		
		if not is_active:
			intentions[bond_index].is_bond = false
			
			if gang.attempt.first_idea:
				gang.attempt.first_idea.intentions[gang.attempt.first_idea.bond_index].is_bond = false

var bond_aspect: Bozo.Aspect:
	set(value_):
		bond_aspect = value_
		update_bond_index()
var bond_element: Bozo.Element:
	set(value_):
		bond_element = value_
		update_bond_index()
var bond_index: int:
	set(value_):
		bond_index = value_
		bond_changed.emit()


func _init(gang_: GangData, index_: int) -> void:
	gang = gang_
	gang.ideas.append(self)
	
	init_intentions(index_)

func init_intentions(index_: int) -> void:
	var opportinity = load("res://entities/isle/mission/gang/idea/opportunity/%d.tres" % index_)
	
	for original_intention in opportinity.intentions:
		var intention = IntentionData.new(original_intention)
		intentions.append(intention)
		intention.idea = self

func update_bond_index() -> void:
	if bond_aspect == null: return
	if bond_element == null: return
	
	for _i in intentions.size():
		var intention = intentions[_i]
		
		if intention.aspect == bond_aspect and intention.element == bond_element:
			bond_index = _i
			return

func update_ambition() -> void:
	for intention in intentions:
		if intention.aspect == bond_aspect and intention.element == bond_element: continue
		
		gang.ambition.aspect_to_potential[intention.aspect].value += 1
		gang.ambition.element_to_potential[intention.element].value += 1

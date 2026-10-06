class_name IdeaData
extends RefCounted


signal active_changed
signal bond_changed
@warning_ignore("unused_signal")
signal attempt_implemented

var intentions: Array[IntentionData]

var is_active: bool = false:
	set(value_):
		is_active = value_
		active_changed.emit()
		
		if not is_active:
			intentions[bond_index].is_bond = false
			
			if Mother.depredation.gang.attempt.first_idea:
				Mother.depredation.gang.attempt.first_idea.intentions[Mother.depredation.gang.attempt.first_idea.bond_index].is_bond = false

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


func _init(cottage_: CottageData, index_: int) -> void:
	cottage_.attic.ideas.append(self)
	
	init_intentions(index_)

func init_intentions(index_: int) -> void:
	var opportinity = load("res://entities/depredation/gang/idea/opportunity/%d.tres" % index_)
	
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

func update_ambition(ambition_: AmbitionData = Mother.depredation.gang.ambition) -> void:
	for intention in intentions:
		if not (ambition_ as GaloreData) and intention.aspect == bond_aspect and intention.element == bond_element: continue
		
		ambition_.aspect_to_potential[intention.aspect].value += 1
		ambition_.element_to_potential[intention.element].value += 1

func transfer() -> void:
	for chamber in Mother.cottage.chambers:
		if chamber.ideas.has(self):
			#if chamber.fol.type ==  Bozo.Room.CELLAR:
				#reset()
			chamber.ideas.erase(self)
			chamber.fol.ideas.append(self)
			return

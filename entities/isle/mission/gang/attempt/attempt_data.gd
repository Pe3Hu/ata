class_name AttemptData
extends RefCounted


signal idea_chaged

var gang: GangData

var first_idea: IdeaData:
	set(value_):
		if first_idea != value_:
			if value_ != null:
				if first_idea != null:
					second_idea = value_
				else:
					if first_idea:
						first_idea.is_active = false
					
					first_idea = value_
			
					if first_idea:
						first_idea.is_active = true
					
					idea_chaged.emit()
			else:
				first_idea = value_
			
				if first_idea:
					first_idea.is_active = true
				
				idea_chaged.emit()
		else:
			if second_idea:
				first_idea.is_active = false
				second_idea = null
				first_idea = null
			else:
				if first_idea:
					first_idea.is_active = false
				
				first_idea = null
		
		if second_idea == null:
			gang.ambition.reset_potentials()
			gang.attempt.reset_impulses()

var second_idea: IdeaData:
	set(value_):
		if second_idea != value_:
			if second_idea:
				second_idea.is_active = false
			
			second_idea = value_
			
			if second_idea:
				second_idea.is_active = true
				#recalc_impulses()
			
			idea_chaged.emit()
		else:
			if second_idea:
				second_idea.is_active = false
			
			second_idea = null

var method_to_impulse: Dictionary
var impulses: Array


func _init(gang_: GangData) -> void:
	gang = gang_
	
	init_impulses()

func init_impulses() -> void:
	for method in Catalog.methods:
		var _impulse = ImpulseData.new(self, method)

func recalc_impulses() -> void:
	reset_impulses()
	var ideas = [first_idea, second_idea]
	
	for idea in ideas:
		for intention in idea.intentions:
			if intention.aspect == idea.bond_aspect and intention.element == idea.bond_element: continue
			intention.update_impulses(self)

func reset_impulses() -> void:
	for impulse in impulses:
		impulse.value = 0

func reset_ideas() -> void:
	first_idea = null

func get_idea_indexs() -> Array:
	var indexs: Array
	indexs.append(gang.ideas.find(first_idea))
	indexs.append(gang.ideas.find(second_idea))
	return indexs

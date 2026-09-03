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

var second_idea: IdeaData:
	set(value_):
		if second_idea != value_:
			if second_idea:
				second_idea.is_active = false
			
			second_idea = value_
			
			if second_idea:
				second_idea.is_active = true
			
			idea_chaged.emit()
		else:
			if second_idea:
				second_idea.is_active = false
			
			second_idea = null

var method_to_impulse: Dictionary
var impulses: Array


func _init(gang_: GangData) -> void:
	gang = gang_

func recalc_impulses() -> void:
	pass

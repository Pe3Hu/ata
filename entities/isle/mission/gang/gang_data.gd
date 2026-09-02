class_name GangData
extends RefCounted


signal idea_chaged

var mission: MissionData

var ideas: Array[IdeaData]

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
			


func _init(mission_: MissionData) -> void:
	mission = mission_
	
	init_ideas()

func init_ideas() -> void:
	var indexs = 8
	
	for index in indexs:
		var _idea = IdeaData.new(self, index + 1)

func test() -> void:
	var n = 21
	
	for _i in range(1, n, 1):
		var a = load('res://entities/isle/mission/gang/idea/opportunity/%d.tres' % _i)
		
		for _j in range(_i + 1, n, 1):
			var b = load('res://entities/isle/mission/gang/idea/opportunity/%d.tres' % _j)
			var r = Helper.find_intersection(a.intentions, b.intentions)
			if r.size() != 1:
				pass

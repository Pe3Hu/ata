class_name GangData
extends RefCounted


var mission: MissionData
var ambition: AmbitionData
var attempt: AttemptData
var plans: Array[PlanData]

var ideas: Array[IdeaData]


func _init(mission_: MissionData) -> void:
	mission = mission_
	
	attempt = AttemptData.new(self)
	ambition = AmbitionData.new(self)
	init_ideas()
	init_plans()
	show_best_methods()

func init_ideas() -> void:
	var indexs = 4
	var options = range(1, Catalog.OPPORTUNINITY_AMOUNT + 1)
	options.shuffle()
	
	for _i in indexs:
		var index = options.pop_back()
		var _idea = IdeaData.new(self, index)

func init_plans() -> void:
	var plan_attempts: Array[AttemptData]
	
	for _i in ideas.size():
			for _j in range(_i + 1, ideas.size(), 1):
				var plan_attempt = AttemptData.new(self)
				plan_attempt.first_idea = ideas[_i]
				plan_attempt.first_idea = ideas[_j]
				plan_attempts.append(plan_attempt)
	
	for _i in plan_attempts.size():
		for _j in range(_i + 1, plan_attempts.size(), 1):
			var a = plan_attempts[_i]
			var b = plan_attempts[_j]
			var _plan = PlanData.new(self, [a, b])
	
	print('___')
	print(plans.size())
	
	#for plan in plans:
		#print('___')
		#for plan_attempt in plan.attempts:
			#var a = ideas.find(plan_attempt.first_idea)
			#var b = ideas.find(plan_attempt.second_idea)
			#print([a, b])

func show_best_methods() -> void:
	plans.sort_custom(func (a, b): return a.best_sum > b.best_sum)
	var best_impulse = plans.front().best_sum
	
	for plan in plans:
		if plan.best_sum != best_impulse: break
		plan.show_best_methods()


func test() -> void:
	var n = 21
	
	for _i in range(1, n, 1):
		var a = load('res://entities/isle/mission/gang/idea/opportunity/%d.tres' % _i)
		
		for _j in range(_i + 1, n, 1):
			var b = load('res://entities/isle/mission/gang/idea/opportunity/%d.tres' % _j)
			var r = Helper.find_intersection(a.intentions, b.intentions)
			if r.size() != 1:
				pass

class_name GangData
extends RefCounted


var depredation: DepredationData
var ambition: AmbitionData
var galore: GaloreData
var attempt: AttemptData
var plans: Array[PlanData]


func _init(depredation_: DepredationData) -> void:
	depredation = depredation_
	
	attempt = AttemptData.new(self)
	ambition = AmbitionData.new(self)
	galore = GaloreData.new(self)
	#init_plans()
	#show_perfect_methods()

func init_plans() -> void:
	var plan_attempts: Array[AttemptData]
	
	for _i in Mother.cottage.kitchen.ideas.size():
			for _j in range(_i + 1, Mother.cottage.kitchen.ideas.size(), 1):
				var plan_attempt = AttemptData.new(self)
				plan_attempt.first_idea = Mother.cottage.kitchen.ideas[_i]
				plan_attempt.first_idea = Mother.cottage.kitchen.ideas[_j]
				plan_attempts.append(plan_attempt)
	
	for _i in plan_attempts.size():
		for _j in range(_i + 1, plan_attempts.size(), 1):
			var a = plan_attempts[_i]
			var b = plan_attempts[_j]
			PlanData.new(self, [a, b])
	
	show_best_methods()
	#print_debug([plans.size(), 'plans'])
	
	#for plan in plans:
		#print_debug('___')
		#for plan_attempt in plan.attempts:
			#var a = ideas.find(plan_attempt.first_idea)
			#var b = ideas.find(plan_attempt.second_idea)
			#print_debug([a, b])

func show_best_methods() -> void:
	plans.sort_custom(func (a, b): return a.best_sum > b.best_sum)
	var best_impulse = plans.front().best_sum
	
	for plan in plans:
		if plan.best_sum != best_impulse: break
		plan.show_best_methods()

func show_perfect_methods() -> void:
	for plan in plans:
		plan.show_perfect_methods()

func test() -> void:
	var n = 21
	
	for _i in range(1, n, 1):
		var a = load('res://entities/isle/depredation/gang/idea/opportunity/%d.tres' % _i)
		
		for _j in range(_i + 1, n, 1):
			var b = load('res://entities/isle/depredation/gang/idea/opportunity/%d.tres' % _j)
			var r = Helper.find_intersection(a.intentions, b.intentions)
			if r.size() != 1:
				pass

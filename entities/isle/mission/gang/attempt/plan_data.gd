class_name PlanData
extends RefCounted


var gang: GangData
var attempts: Array[AttemptData]

var method_to_sum: Dictionary
var best_sum: int
var best_methods: Array[Bozo.Method]


func _init(gang_: GangData, attempts_: Array) -> void:
	gang = gang_
	
	init_attempts(attempts_)
	
	if is_attempts_unique():
		gang.plans.append(self)
		calc_sums()

func is_attempts_unique() -> bool:
	var ideas = []
	
	for attempt in attempts:
		if ideas.has(attempt.first_idea): return false
		ideas.append(attempt.first_idea)
		if ideas.has(attempt.second_idea): return false
		ideas.append(attempt.second_idea)
	
	return true

func init_attempts(attempts_: Array) -> void:
	for _attempt in attempts_:
		var attempt = AttemptData.new(gang)
		attempt.first_idea = _attempt.first_idea
		attempt.second_idea = _attempt.second_idea
		attempts.append(attempt)
		
		var intention_data = Helper.find_intersection(attempt.first_idea, attempt.second_idea).front()
		attempt.first_idea.bond_aspect = intention_data.aspect
		attempt.first_idea.bond_element = intention_data.element
		attempt.second_idea.bond_aspect = intention_data.aspect
		attempt.second_idea.bond_element = intention_data.element

func calc_sums() -> void:
	method_to_sum.clear()
	best_methods.clear()
	best_sum = 0
	
	for method in Catalog.methods:
		method_to_sum[method] = 0
	
	for attempt in attempts:
		attempt.recalc_impulses()
		
		for impulse in attempt.impulses:
			method_to_sum[impulse.method] += impulse.value
	
	for method in method_to_sum:
		if best_sum == method_to_sum[method]:
			best_methods.append(method)
		
		if best_sum < method_to_sum[method]:
			best_sum = method_to_sum[method]
			best_methods = [method]

func show_best_methods() -> void:
	var str_methods = []
	
	for method in best_methods:
		var str_method = Bozo.enum_to_string(Bozo.Type.METHOD, method)
		str_methods.append(str_method)
	
	var idea_indexs = []
	
	for attempt in attempts:
		idea_indexs.append(attempt.get_idea_indexs())
	
	print([best_sum, str_methods, idea_indexs])

class_name MissionData
extends RefCounted


var isle: IsleData

var bank: BankData
var gang: GangData

var counter = 1000
var method_to_sum: Dictionary


func _init(isle_: IsleData) -> void:
	isle = isle_
	
	bank = BankData.new(self)
	gang = GangData.new(self)

func test_avg_difficulty() -> void:
	for method in Catalog.methods:
		method_to_sum[method] = 0.0
	
	var avg_max = 0.0
	var avg_min = 100.0
	var _k = 0
	
	for _c in counter:
		bank = BankData.new(self)
		gang = GangData.new(self)
		var max_impulse = 0
		var min_impulse = 0
		
		for _i in gang.ideas.size():
			for _j in range(_i + 1, gang.ideas.size(), 1):
				gang.attempt.first_idea = gang.ideas[_i]
				gang.attempt.first_idea = gang.ideas[_j]
				#gang.attempt.second_idea = gang.ideas[_j]
				#gang.attempt.recalc_impulses()
				
				for impulse in gang.attempt.impulses:
					method_to_sum[impulse.method] += impulse.value
					
					if impulse.value > max_impulse:
						max_impulse = impulse.value
					if impulse.value < min_impulse and impulse.value > 5:
						min_impulse = impulse.value
				
				_k += 1
		
		avg_max += max_impulse
		avg_min += min_impulse
	
	gang.attempt.reset_ideas()
	avg_max /= counter
	avg_min /= counter
	print([gang.ideas.size(), snapped(avg_min, 0.1), snapped(avg_max, 0.1)])
	#for method in method_to_sum:
		#method_to_sum[method] /= _k
		#print([Bozo.enum_to_string(Bozo.Type.METHOD, method), snapped(method_to_sum[method], 0.1)])

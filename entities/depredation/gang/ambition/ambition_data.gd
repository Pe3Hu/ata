class_name AmbitionData
extends RefCounted


var gang: GangData

var potentials: Array[PotentialData]
var aspects: Array[PotentialData]
var elements: Array[PotentialData]
var aspect_to_potential: Dictionary
var element_to_potential: Dictionary


func _init(gang_: GangData) -> void:
	gang = gang_
	
	init_potentials()

func init_potentials() -> void:
	for aspect in Catalog.aspects:
		var potential = PotentialData.new(self, aspect)
		aspect_to_potential[aspect] = potential
		aspects.append(potential)
		potentials.append(potential)
	
	for element in Catalog.elements:
		var potential = PotentialData.new(self, Bozo.Aspect.NONE, element)
		element_to_potential[element] = potential
		elements.append(potential)
		potentials.append(potential)

func recalc_potentials() -> void:
	reset_potentials()
	
	gang.attempt.first_idea.update_ambition()
	gang.attempt.second_idea.update_ambition()
	
	aspects.sort_custom(func (a, b): return a.value > b.value)
	elements.sort_custom(func (a, b): return a.value > b.value)
	
	for _i in aspects.size():
		var aspect = aspects[_i]
		aspect.index = _i
		
	for _i in elements.size():
		var element = elements[_i]
		element.index = _i

func reset_potentials() -> void:
	for potential in potentials:
		potential.value = 0

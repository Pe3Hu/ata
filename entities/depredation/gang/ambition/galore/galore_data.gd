class_name GaloreData
extends AmbitionData


func recalc_potentials() -> void:
	reset_potentials()
	
	for idea in Mother.cottage.kitchen.ideas:
		idea.update_ambition(self)
	
	aspects.sort_custom(func (a, b): return a.value > b.value)
	elements.sort_custom(func (a, b): return a.value > b.value)
	
	for _i in aspects.size():
		var aspect = aspects[_i]
		aspect.index = _i
		
	for _i in elements.size():
		var element = elements[_i]
		element.index = _i

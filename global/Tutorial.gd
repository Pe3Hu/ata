extends Node


const is_active: bool = true

const wasteland_indexs = [3, 5, 12, 13]
const shelter_indexs = [14]

const index_to_structures = {
	3: [
		Bozo.Structure.WORKSHOP,
		Bozo.Structure.FORGE,
	],
	5: [
		Bozo.Structure.OBSERVATORY,
		Bozo.Structure.LIGHTHOUSE,
	],
	12: [
		Bozo.Structure.TAVERN,
		Bozo.Structure.THEATER,
	],
	13: [
		Bozo.Structure.MINE,
		Bozo.Structure.ATELIER,
	],
}

const mixed_matters = [Bozo.Matter.GAS, Bozo.Matter.LIQUID]

const brief_structures = [
	Bozo.Structure.WORKSHOP,
	Bozo.Structure.FORGE,
	Bozo.Structure.OBSERVATORY,
	Bozo.Structure.LIGHTHOUSE,
	Bozo.Structure.TAVERN,
	Bozo.Structure.THEATER,
	Bozo.Structure.MINE,
	Bozo.Structure.ATELIER,
]

func stages() -> Array:
	if not is_active:
		return []

	var result: Array = []
	for index in brief_structures.size():
		var type: Bozo.Structure = brief_structures[index]
		var text := _brief_text(type)
		var target := _first_structure.bind(type)
		if index == 0:
			result.append(Stage.after(1.0, text, target))
		else:
			result.append(Stage.now(text, target))
	return result


func _brief_text(type: Bozo.Structure) -> String:
	var structure_name := Bozo.enum_to_string(Bozo.Type.STRUCTURE, type)
	var article := "an" if "aeiou".contains(structure_name.substr(0, 1)) else "a"
	return "This is %s %s." % [article, structure_name]


func _first_structure(type: Bozo.Structure) -> StructureData:
	for wasteland in Mother.mainland.wastelands:
		for structure in wasteland.structures:
			if structure.type == type:
				return structure
	return null

extends Node


var faction_to_color: Dictionary
var sum_to_matter_to_intro: Dictionary


#region matter
const verse_to_matter = {
	35: [
		Bozo.Matter.GAS,
		Bozo.Matter.LIQUID,
	],
	34: [
		Bozo.Matter.GAS,
		Bozo.Matter.SOLID,
	],
	36: [
		Bozo.Matter.LIQUID,
		Bozo.Matter.SOLID,
	],
	59: [
		Bozo.Matter.GAS,
		Bozo.Matter.LIQUID,
	],
	57: [
		Bozo.Matter.GAS,
		Bozo.Matter.SOLID,
	],
	58: [
		Bozo.Matter.LIQUID,
		Bozo.Matter.SOLID,
	],
	89: [
		Bozo.Matter.GAS,
		Bozo.Matter.LIQUID,
	],
	87: [
		Bozo.Matter.GAS,
		Bozo.Matter.SOLID,
	],
	88: [
		Bozo.Matter.LIQUID,
		Bozo.Matter.SOLID,
	],
}

const matter_to_verse = {
	Bozo.Matter.NONE: [34, 35, 36],
	Bozo.Matter.GAS: [34, 35],
	Bozo.Matter.LIQUID: [35, 36],
	Bozo.Matter.SOLID: [34, 36],
}

const matter_to_factors = {
	Bozo.Matter.NONE: [2, 3, 5],
	Bozo.Matter.GAS: [2, 3],
	Bozo.Matter.LIQUID: [2, 3],
	Bozo.Matter.SOLID: [3, 5],
}

const factor_to_matter = {
	2: Bozo.Matter.GAS,
	3: Bozo.Matter.LIQUID,
	5: Bozo.Matter.SOLID,
}

const matter_to_factor = {
	Bozo.Matter.GAS: 2,
	Bozo.Matter.LIQUID: 3,
	Bozo.Matter.SOLID: 5,
}

const expiration_to_factor = {
	Bozo.Matter.GAS: 2,
	Bozo.Matter.LIQUID: 3,
	Bozo.Matter.SOLID: 4,
}
#endregion

#region grade
const sum_to_index = {
	20: 11,
	30: 20,
	40: 22
}

const sum_to_grades = {
	20: [1, 2],#[0, 1, 2],
	30: [2, 3],#[1, 2, 3, 4],#[1, 2, 3],
	40: [3, 4]#[2, 3, 4],
}
#endregion

#region stamp
const tune_to_length_to_joints = {
	Bozo.Tune.INTRO: {
		1: [[2, 3]],
		2: [[1, 2], [3, 4]],
		3: [[0, 1], [2, 3], [4, 5]],
		6: [[0], [1], [2], [3], [4], [5]]
	},
	Bozo.Tune.VERSE: {
		1: [[2]],
		2: [[2], [3]],
		3: [[3], [4], [5]],
		6: [[0], [1], [2], [3]]
	},
	Bozo.Tune.OUTRO: {
		1: [[3]],
		2: [[1], [4]],
		3: [[0, 1, 2]],
		6: [[4, 5]]
	},
}
#endregion

#region canto
const tune_to_stake = {
	Bozo.Tune.INTRO: Bozo.Stake.RIGHT,
	Bozo.Tune.VERSE: Bozo.Stake.LEFT,
	Bozo.Tune.OUTRO: Bozo.Stake.LEFT,
}

const tune_to_math = {
	Bozo.Tune.VERSE: Bozo.Math.PLUS,
	Bozo.Tune.OUTRO: Bozo.Math.MULTIPLY,
}

var verse_to_spoil = {
	34: 1,
	35: 1,
	36: 1,
	57: 2,
	58: 2,
	59: 2,
	87: 3,
	88: 3,
	89: 3
}
#endregion



#region fake dice
var side_to_axis_to_side = {
	0: {
		0: 4,
		1: 3,
		2: 0
	},
	1: {
		0: 0,
		1: 2,
		2: 1
	},
	2: {
		0: 0,
		1: 0,
		2: 2
	},
	3: {
		0: 1,
		1: 5,
		2: 3
	},
	4: {
		0: 5,
		1: 3,
		2: 4
	},
	5: {
		0: 1,
		1: 2,
		2: 5
	}
}

var rotation_to_face = {
	Vector3(0, 0, 0): 0,
	Vector3(0, 0, 90): 0,
	Vector3(0, 0, 180): 0,
	Vector3(0, 0, 270): 0,
	Vector3(0, 90, 0): 3,
	Vector3(0, 90, 90): 4,
	Vector3(0, 90, 180): 2,
	Vector3(0, 90, 270): 1,
	Vector3(0, 180, 0): 5,
	Vector3(0, 180, 90): 5,
	Vector3(0, 180, 180): 5,
	Vector3(0, 180, 270): 5,
	Vector3(0, 270, 0): 2,
	Vector3(0, 270, 90): 1,
	Vector3(0, 270, 180): 3,
	Vector3(0, 270, 270): 4,
	Vector3(90, 0, 0): 1,
	Vector3(90, 0, 90): 3,
	Vector3(90, 0, 180): 4,
	Vector3(90, 0, 270): 2,
	Vector3(90, 90, 0): 3,
	Vector3(90, 90, 90): 4,
	Vector3(90, 90, 180): 2,
	Vector3(90, 90, 270): 1,
	Vector3(90, 180, 0): 4,
	Vector3(90, 180, 90): 2,
	Vector3(90, 180, 180): 1,
	Vector3(90, 180, 270): 3,
	Vector3(90, 270, 0): 2,
	Vector3(90, 270, 90): 1,
	Vector3(90, 270, 180): 3,
	Vector3(90, 270, 270): 4,
	Vector3(180, 0, 0): 5,
	Vector3(180, 0, 90): 5,
	Vector3(180, 0, 180): 5,
	Vector3(180, 0, 270): 5,
	Vector3(180, 90, 0): 3,
	Vector3(180, 90, 90): 4,
	Vector3(180, 90, 180): 2,
	Vector3(180, 90, 270): 1,
	Vector3(180, 180, 0): 0,
	Vector3(180, 180, 90): 0,
	Vector3(180, 180, 180): 0,
	Vector3(180, 180, 270): 0,
	Vector3(180, 270, 0): 2,
	Vector3(180, 270, 90): 1,
	Vector3(180, 270, 180): 3,
	Vector3(180, 270, 270): 4,
	Vector3(270, 0, 0): 4,
	Vector3(270, 0, 90): 2,
	Vector3(270, 0, 180): 1,
	Vector3(270, 0, 270): 3,
	Vector3(270, 90, 0): 3,
	Vector3(270, 90, 90): 4,
	Vector3(270, 90, 180): 2,
	Vector3(270, 90, 270): 1,
	Vector3(270, 180, 0): 1,
	Vector3(270, 180, 90): 3,
	Vector3(270, 180, 180): 4,
	Vector3(270, 180, 270): 2,
	Vector3(270, 270, 0): 2,
	Vector3(270, 270, 90): 1,
	Vector3(270, 270, 180): 3,
	Vector3(270, 270, 270): 4,
}

var face_to_rotations = {
	0: [
		Vector3(0, 0, 0), Vector3(0, 0, 90), Vector3(0, 0, 180), Vector3(0, 0, 270),
		Vector3(180, 180, 0), Vector3(180, 180, 90), Vector3(180, 180, 180), Vector3(180, 180, 270)
	],
	1: [
		Vector3(0, 90, 270), Vector3(0, 270, 90), Vector3(90, 0, 0), Vector3(90, 90, 270),
		Vector3(90, 180, 180), Vector3(90, 270, 90), Vector3(180, 90, 270), Vector3(180, 270, 90),
		Vector3(270, 0, 180), Vector3(270, 90, 270), Vector3(270, 180, 0), Vector3(270, 270, 90)
	],
	2: [
		Vector3(0, 90, 180), Vector3(0, 270, 0), Vector3(90, 0, 270), Vector3(90, 90, 180),
		Vector3(90, 180, 90), Vector3(90, 270, 0), Vector3(180, 90, 180), Vector3(180, 270, 0),
		Vector3(270, 0, 90), Vector3(270, 90, 180), Vector3(270, 180, 270), Vector3(270, 270, 0)
	],
	3: [
		Vector3(0, 90, 0), Vector3(0, 270, 180), Vector3(90, 0, 90), Vector3(90, 90, 0),
		Vector3(90, 180, 270), Vector3(90, 270, 180), Vector3(180, 90, 0), Vector3(180, 270, 180),
		Vector3(270, 0, 270), Vector3(270, 90, 0), Vector3(270, 180, 90), Vector3(270, 270, 180)
	],
	4: [
		Vector3(0, 90, 90), Vector3(0, 270, 270), Vector3(90, 0, 180), Vector3(90, 90, 90),
		Vector3(90, 180, 0), Vector3(90, 270, 270), Vector3(180, 90, 90), Vector3(180, 270, 270),
		Vector3(270, 0, 0), Vector3(270, 90, 90), Vector3(270, 180, 180), Vector3(270, 270, 270)
	],
	5: [
		Vector3(0, 180, 0), Vector3(0, 180, 90), Vector3(0, 180, 180), Vector3(0, 180, 270),
		Vector3(180, 0, 0), Vector3(180, 0, 90), Vector3(180, 0, 180), Vector3(180, 0, 270)
	]
}

var face_to_normals = {
	0: [
		Vector3(0.0, 0.0, 0.0),
		Vector3(180.0, 180.0, 180.0)
	],
	1: [
		Vector3(90.0, 0.0, 0.0),
		Vector3(90.0, 90.0, 270.0),
		Vector3(90.0, 180.0, 180.0),
		Vector3(90.0, 270.0, 90.0)
	],
	2: [
		Vector3(0.0, 270.0, 0.0),
		Vector3(180.0, 90.0, 180.0)
	],
	3: [
		Vector3(0.0, 90.0, 0.0),
		Vector3(180.0, 270.0, 180.0)
	],
	4: [
		Vector3(270.0, 0.0, 0.0),
		Vector3(270.0, 90.0, 90.0),
		Vector3(270.0, 180.0, 180.0),
		Vector3(270.0, 270.0, 270.0)
	],
	5: [
		Vector3(0.0, 180.0, 0.0),
		Vector3(180.0, 0.0, 180.0)
	]
}

var normal_to_mirror = {
	Vector3(270.0, 0.0, 180.0): Vector3(270.0, 90.0, 270.0),
	Vector3(270.0, 180.0, 0.0): Vector3(270.0, 90.0, 270.0),
	Vector3(90.0, 0.0, 270.0): Vector3(90.0, 90.0, 180.0),
	Vector3(90.0, 180.0, 90.0): Vector3(90.0, 90.0, 180.0),
	Vector3(270.0, 0.0, 90.0): Vector3(270.0, 90.0, 180.0),
	Vector3(270.0, 180.0, 270.0): Vector3(270.0, 90.0, 180.0),
	Vector3(90.0, 0.0, 90.0): Vector3(90.0, 90.0, 0.0),
	Vector3(90.0, 180.0, 270.0): Vector3(90.0, 90.0, 0.0),
	Vector3(270.0, 0.0, 270.0): Vector3(270.0, 270.0, 180.0),
	Vector3(270.0, 180.0, 90.0): Vector3(270.0, 270.0, 180.0),
	Vector3(90.0, 0.0, 180.0): Vector3(90.0, 90.0, 90.0),
	Vector3(90.0, 180.0, 0.0): Vector3(90.0, 90.0, 90.0),
}
#endregion

#region color
var matter_to_color = {
	Bozo.Matter.NONE: Color.WHITE,
	Bozo.Matter.ANY: Color.DIM_GRAY,
	Bozo.Matter.SOLID: Color.from_hsv(30.0 / 360.0, 0.75, 0.75),
	Bozo.Matter.LIQUID: Color.from_hsv(150.0 / 360.0, 0.75, 0.75),
	Bozo.Matter.GAS: Color.from_hsv(270.0 / 360.0, 0.75, 0.75),
}

var matter_to_hue = {
	Bozo.Matter.SOLID: 0.05,
	Bozo.Matter.LIQUID: 0.35,
	Bozo.Matter.GAS: 0.75,
}

var matter_to_pallete = [
	Color.from_hsv(0.0, 1.0, 0.2),
	Color.from_hsv(0.0416, 0.6, 0.7),
	Color.from_hsv(0.0416, 0.8, 1.0),
]


var element_to_color = {
	Bozo.Element.CLOUD: Color.from_hsv(0.0 / 360.0, 0.0, 0.75),
	Bozo.Element.VAPOR: Color.from_hsv(0.35 / 360.0, 0.75, 0.75),
	Bozo.Element.DUST: Color.from_hsv(0.0 / 360.0, 0.0, 0.75),
	Bozo.Element.SAND: Color.from_hsv(0.15 / 360.0, 0.75, 0.25),
	Bozo.Element.ICE: Color.from_hsv(0.55 / 360.0, 0.75, 0.75),
	Bozo.Element.LAVA: Color.from_hsv(0.0 / 360.0, 0.75, 0.75),
	Bozo.Element.CHAOS: Color.from_hsv(0.85 / 360.0, 0.75, 0.75),
}


var canto_to_selection = {
	true: Color.LIGHT_GRAY,
	false: Color.WEB_GRAY,
}
#endregion


func _init() -> void:
	init_intros()

func init_intros() -> void:
	sum_to_matter_to_intro.clear()
	
	for sum in sum_to_index:
		sum_to_matter_to_intro[sum] = {}
		
		for matter in Catalog.matters:
			sum_to_matter_to_intro[sum][matter] = []
		
		for index in sum_to_index[sum] + 1:
			var matters: Array[Bozo.Matter] = []
			var dice = load("res://entities/dice/datas/intro/%d_%d.tres" % [sum, index])
			
			for value in dice.values:
				for matter in Helper.get_matters(value):
					if not matters.has(matter):
						matters.append(matter)
			
			for matter in matters:
				sum_to_matter_to_intro[sum][matter].append(dice)

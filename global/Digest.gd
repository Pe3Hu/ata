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

const volume_to_matter_to_volume = {
	2: {
		Bozo.Matter.GAS: 4,
		Bozo.Matter.LIQUID: 5,
	},
	3: {
		Bozo.Matter.GAS: 5,
		Bozo.Matter.LIQUID: 6,
		Bozo.Matter.SOLID: 8,
	},
	4: {
		Bozo.Matter.GAS: 6,
		Bozo.Matter.SOLID: 9,
	},
	5: {
		Bozo.Matter.LIQUID: 8,
		Bozo.Matter.SOLID: 10,
	},
	6: {
		Bozo.Matter.GAS: 8,
		Bozo.Matter.LIQUID: 9,
	},
	8: {
		Bozo.Matter.GAS: 10,
	},
	9: {
		Bozo.Matter.LIQUID: 12,
	},
	10: {
		Bozo.Matter.GAS: 12,
		Bozo.Matter.SOLID: 15,
	},
	12: {
		Bozo.Matter.LIQUID: 15,
	},
	15: {
		Bozo.Matter.LIQUID: 18,
		Bozo.Matter.SOLID: 20,
	},
	18: {
		Bozo.Matter.GAS: 20,
	},
	20: {
		Bozo.Matter.SOLID: 25,
	},
	25: {
		Bozo.Matter.GAS: 27,
		Bozo.Matter.SOLID: 30,
	},
	27: {
		Bozo.Matter.LIQUID: 30,
		Bozo.Matter.SOLID: 32,
	},
	30: {
		Bozo.Matter.GAS: 32,
	},
	32: {},
}

const volume_to_coord = {
	2: Vector2i(2, 8),
	3: Vector2i(2, 7),
	4: Vector2i(4, 7),
	5: Vector2i(0, 7),
	6: Vector2i(3, 6),
	8: Vector2i(1, 6),
	9: Vector2i(4, 5),
	10: Vector2i(0, 5),
	12: Vector2i(2, 5),
	15: Vector2i(1, 4),
	18: Vector2i(3, 4),
	20: Vector2i(2, 3),
	25: Vector2i(2, 2),
	27: Vector2i(3, 1),
	30: Vector2i(1, 1),
	32: Vector2i(2, 0)
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

#region method
const obstacle_to_methods = {
	Bozo.Obstacle.LOCK: [
		Bozo.Method.RAKE,
		Bozo.Method.HACK,
	],
	Bozo.Obstacle.WALL: [
		Bozo.Method.BREAK,
		Bozo.Method.FIND,
	],
	Bozo.Obstacle.CUSTODIAN: [
		Bozo.Method.KILL,
		Bozo.Method.STEAL,
	],
}

const method_to_aspect_to_factor = {
	Bozo.Method.RAKE: {
		Bozo.Aspect.STRENGTH: 1,
		Bozo.Aspect.DEXTERITY: 2,
	},
	Bozo.Method.HACK: {
		Bozo.Aspect.STRENGTH: 1,
		Bozo.Aspect.INTELLECT: 2,
	},
	Bozo.Method.BREAK: {
		Bozo.Aspect.STRENGTH: 2,
		Bozo.Aspect.DEXTERITY: 1,
	},
	Bozo.Method.FIND: {
		Bozo.Aspect.DEXTERITY: 1,
		Bozo.Aspect.INTELLECT: 2,
	},
	Bozo.Method.KILL: {
		Bozo.Aspect.STRENGTH: 2,
		Bozo.Aspect.INTELLECT: 1,
	},
	Bozo.Method.STEAL: {
		Bozo.Aspect.DEXTERITY: 2,
		Bozo.Aspect.INTELLECT: 1,
	},
}

const method_to_factor_to_aspect = {
	Bozo.Method.RAKE: {
		1: Bozo.Aspect.STRENGTH,
		2: Bozo.Aspect.DEXTERITY,
	},
	Bozo.Method.HACK: {
		1: Bozo.Aspect.STRENGTH,
		2: Bozo.Aspect.INTELLECT,
	},
	Bozo.Method.BREAK: {
		2: Bozo.Aspect.STRENGTH,
		1: Bozo.Aspect.DEXTERITY,
	},
	Bozo.Method.FIND: {
		1: Bozo.Aspect.DEXTERITY,
		2: Bozo.Aspect.INTELLECT,
	},
	Bozo.Method.KILL: {
		2: Bozo.Aspect.STRENGTH,
		1: Bozo.Aspect.INTELLECT,
	},
	Bozo.Method.STEAL: {
		2: Bozo.Aspect.DEXTERITY,
		1: Bozo.Aspect.INTELLECT,
	},
}

const aspect_to_method_to_factor = {
	Bozo.Aspect.STRENGTH: {
		Bozo.Method.RAKE: 1,
		Bozo.Method.HACK: 1,
		Bozo.Method.BREAK: 2,
		Bozo.Method.KILL: 2,
	},
	Bozo.Aspect.DEXTERITY: {
		Bozo.Method.RAKE: 2,
		Bozo.Method.BREAK: 1,
		Bozo.Method.FIND: 1,
		Bozo.Method.STEAL: 2,
	},
	Bozo.Aspect.INTELLECT: {
		Bozo.Method.HACK: 2,
		Bozo.Method.FIND: 2,
		Bozo.Method.KILL: 1,
		Bozo.Method.STEAL: 1,
	},
}

const method_to_element = {
	Bozo.Method.RAKE: Bozo.Element.SAND,
	Bozo.Method.HACK: Bozo.Element.ICE,
	Bozo.Method.BREAK: Bozo.Element.LAVA,
	Bozo.Method.FIND: Bozo.Element.CLOUD,
	Bozo.Method.KILL: Bozo.Element.DUST,
	Bozo.Method.STEAL: Bozo.Element.VAPOR,
}

const element_to_method = {
	Bozo.Element.SAND: Bozo.Method.RAKE,
	Bozo.Element.ICE: Bozo.Method.HACK,
	Bozo.Element.LAVA: Bozo.Method.BREAK,
	Bozo.Element.CLOUD: Bozo.Method.FIND,
	Bozo.Element.DUST: Bozo.Method.KILL,
	Bozo.Element.VAPOR: Bozo.Method.STEAL,
}

const element_to_index = {
	Bozo.Element.SAND: 4,
	Bozo.Element.ICE: 2,
	Bozo.Element.LAVA: 1,
	Bozo.Element.CLOUD: 5,
	Bozo.Element.DUST: 6,
	Bozo.Element.VAPOR: 3,
	Bozo.Element.CHAOS: 0
}

const elememt_to_in = {
	Bozo.Element.CLOUD: Bozo.Matter.GAS,
	Bozo.Element.VAPOR: Bozo.Matter.LIQUID,
	Bozo.Element.DUST: Bozo.Matter.GAS,
	Bozo.Element.SAND: Bozo.Matter.SOLID,
	Bozo.Element.ICE: Bozo.Matter.LIQUID,
	Bozo.Element.LAVA: Bozo.Matter.SOLID,
}

const elememt_to_out = {
	Bozo.Element.CLOUD: Bozo.Matter.LIQUID,
	Bozo.Element.VAPOR: Bozo.Matter.GAS,
	Bozo.Element.DUST: Bozo.Matter.SOLID,
	Bozo.Element.SAND: Bozo.Matter.GAS,
	Bozo.Element.ICE: Bozo.Matter.SOLID,
	Bozo.Element.LAVA: Bozo.Matter.LIQUID,
}
#endregion

#region flux
const flux_to_crown = {
	2: 5,
	3: 5,
	4: 5,
	5: 5,
	6: 5,
	8: 5,
	9: 6,
	10: 6,
	12: 6,
	15: 6,
	18: 6,
	20: 6,
	25: 4,
	27: 4,
	30: 4,
	32: 4,
}

const flux_to_index = {
	2: 0,
	3: 2,
	4: 3,
	5: 1,
	6: 5,
	8: 4,
	9: 2,
	10: 0,
	12: 1,
	15: 3,
	18: 4,
	20: 5,
	25: 0,
	27: 2,
	30: 1,
	32: 3,
}

var crown_to_face_to_bordes = {
	4: [    
		Vector2(13.0, 12.0),
		Vector2(33.0, 32.0),
		Vector2(43.0, 22.0),
		Vector2(23.0, 2.0),
		Vector2(3.0, 22.0),
		Vector2(23.0, 42.0),
		Vector2(43.0, 22.0),
		Vector2(33.0, 12.0),
		Vector2(13.0, 32.0),
	],
	5: [
		Vector2(31.0, 35.0),
		Vector2(37.0, 44.0),
		Vector2(48.0, 34.0),
		Vector2(48.0, 16.0),
		Vector2(36.0, 21.0),
		Vector2(31.0, 35.0),
		Vector2(17.0, 35.0),
		Vector2(11.0, 44.0),
		Vector2(24.0, 49.0),
		Vector2(37.0, 44.0),
		Vector2(31.0, 35.0),
		Vector2(17.0, 35.0),
		Vector2(12.0, 21.0),
		Vector2(0.0, 16.0),
		Vector2(0.0, 34.0),
		Vector2(11.0, 44.0),
		Vector2(0.0, 34.0),
		Vector2(0.0, 16.0),
		Vector2(9.0, 4.0),
		Vector2(24.0, -1.0),
		Vector2(39.0, 4.0),
		Vector2(48.0, 16.0),
		Vector2(36.0, 21.0),
		Vector2(24.0, 11.0),
		Vector2(24.0, -1.0),
		Vector2(24.0, 11.0),
		Vector2(12.0, 21.0)
	],
	6: [
		Vector2(49.0, 46.0),
		Vector2(24.0, 3.0),
		Vector2(16.0, 16.0),
		Vector2(32.0, 16.0),
		Vector2(24.0, 31.0),
		Vector2(41.0, 31.0),
		Vector2(33.0, 46.0),
		Vector2(24.0, 31.0),
		Vector2(15.0, 46.0),
		Vector2(7.0, 31.0),
		Vector2(24.0, 31.0),
		Vector2(16.0, 16.0),
		Vector2(-1.0, 46.0),
		Vector2(49.0, 46.0),
	]
}

var crown_to_face_to_points = {
	4: [
		[Vector2(13.0, 32.0), Vector2(23.0, 42.0), Vector2(33.0, 32.0), Vector2(23.0, 22.0)],
		[Vector2(13.0, 32.0), Vector2(3.0, 22.0), Vector2(13.0, 12.0), Vector2(23.0, 22.0)],
		[Vector2(33.0, 12.0), Vector2(43.0, 22.0), Vector2(33.0, 32.0), Vector2(23.0, 22.0)],
		[Vector2(33.0, 12.0), Vector2(23.0, 2.0), Vector2(13.0, 12.0), Vector2(23.0, 22.0)],
	],
	5: [
		[Vector2(31, 35), Vector2(37, 44), Vector2(24, 49), Vector2(11, 44), Vector2(17, 35)],
		[Vector2(17, 35), Vector2(11, 44), Vector2(0, 34), Vector2(0, 16), Vector2(12, 21)],
		[Vector2(31, 35), Vector2(36, 21), Vector2(24, 11), Vector2(12, 21), Vector2(17, 35)],
		[Vector2(31, 35), Vector2(37, 44), Vector2(48, 34), Vector2(48, 16), Vector2(36, 21)],
		[Vector2(12, 21), Vector2(0, 16), Vector2(9, 4), Vector2(24, -1), Vector2(24, 11)],
		[Vector2(24, -1), Vector2(39, 4), Vector2(48, 16), Vector2(36, 21), Vector2(24, 11)],
	],
	6: [
		[Vector2(13.0, 45.0), Vector2(6.0, 33.0), Vector2(0.0, 45.0)],
		[Vector2(31.0, 45.0), Vector2(24.0, 33.0), Vector2(17.0, 45.0)],
		[Vector2(49.0, 45.0), Vector2(42.0, 33.0), Vector2(34.0, 45.0)],
		[Vector2(23.0, 30.0), Vector2(15.0, 18.0), Vector2(8.0, 30.0)],
		[Vector2(41.0, 30.0), Vector2(33.0, 18.0), Vector2(26.0, 30.0)],
		[Vector2(33.0, 15.0), Vector2(24.0, 3.0), Vector2(16.0, 15.0)]
	]
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
	Bozo.Element.CLOUD: Color.from_hsv(0 / 360.0, 0.0, 0.75),
	Bozo.Element.DUST: Color.from_hsv(125 / 360.0, 0.75, 0.75),
	Bozo.Element.VAPOR: Color.from_hsv(0 / 360.0, 0.0, 0.25),
	Bozo.Element.SAND: Color.from_hsv(55 / 360.0, 0.75, 0.75),
	Bozo.Element.ICE: Color.from_hsv(205 / 360.0, 0.75, 0.75),
	Bozo.Element.LAVA: Color.from_hsv(0 / 360.0, 0.75, 0.75),
	Bozo.Element.CHAOS: Color.from_hsv(305 / 360.0, 0.75, 0.75),
}

var element_to_hue = {
	Bozo.Element.CLOUD: 0.0,
	Bozo.Element.VAPOR: 0.0,
	Bozo.Element.DUST: 0.35,
	Bozo.Element.SAND: 0.15,
	Bozo.Element.ICE: 0.55,
	Bozo.Element.LAVA: 0.0,
	Bozo.Element.CHAOS: 0.85
}

var aspect_to_color = {
	Bozo.Aspect.STRENGTH: Color.from_hsv(30.0 / 360.0, 0.75, 0.75),
	Bozo.Aspect.INTELLECT: Color.from_hsv(150.0 / 360.0, 0.75, 0.75),
	Bozo.Aspect.DEXTERITY: Color.from_hsv(270.0 / 360.0, 0.75, 0.75),
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

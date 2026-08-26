extends Node



#region matter
const matters: Array[Bozo.Matter] = [
	Bozo.Matter.GAS,
	Bozo.Matter.LIQUID,
	Bozo.Matter.SOLID,
]

var outro_to_matter_to_values: Dictionary = {
	0: {
		Bozo.Matter.GAS: [2, 3, 4, 5],
		Bozo.Matter.LIQUID: [2, 3],
		Bozo.Matter.SOLID: [2]
	},
	1: {
		Bozo.Matter.GAS: [6, 8, 9, 10],
		Bozo.Matter.LIQUID: [4, 5, 6],
		Bozo.Matter.SOLID: [3, 4]
	},
	2: {
		Bozo.Matter.GAS: [12, 15, 18, 20],
		Bozo.Matter.LIQUID: [8, 9, 10, 12],
		Bozo.Matter.SOLID: [5, 6, 8]
	},
	3: {
		Bozo.Matter.GAS: [25, 27, 30],
		Bozo.Matter.LIQUID: [15, 18, 20],
		Bozo.Matter.SOLID: [9, 10, 12]
	},
	4: {
		Bozo.Matter.GAS: [32],
		Bozo.Matter.LIQUID: [25, 27, 30, 32],
		Bozo.Matter.SOLID: [15, 18, 20]
	}
}

var matter_to_factor = {
	Bozo.Matter.SOLID: 5,
	Bozo.Matter.LIQUID: 3,
	Bozo.Matter.GAS: 2,
}

#endregion

#region canto
const tunes = [
	Bozo.Tune.INTRO,
	Bozo.Tune.VERSE,
	Bozo.Tune.OUTRO
]

var grids = [
	Vector2i(0, 0),
	Vector2i(0, 1),
	Vector2i(0, 2),
	Vector2i(1, 0),
	Vector2i(1, 1),
	Vector2i(1, 2),
]

var net_neighbors = {
	0: [3, 1, 2],
	1: [4, 2, 0],
	2: [5, 0, 1],
	3: [0, 4, 5],
	4: [1, 5, 3],
	5: [2, 3, 4]
}

var volumes = [2, 3, 4, 5, 6, 8, 9, 10, 12, 15, 18, 20, 25, 27, 30, 32]
var prime_volumes = [2, 3, 5]

var pulses = [0, 2, 3, 4, 5, 6, 8, 9, 10, 12, 15, 18, 20, 24, 25, 27, 30, 
		32, 36, 40, 45, 50, 54, 60, 64, 75, 81, 90, 96, 100]

var chorus_values = {
	"I": [7, 11, 13, 17, 19, 23],
	"II": [19, 23, 29, 31, 37, 41],
	"III": [37, 41, 43, 47, 53, 59],
	"IV": [53, 59, 61, 67, 71, 73],
	"V": [71, 73, 79, 83, 89, 97]
}

const verse_indexs = [34, 35, 36]

const OUTRO_BASE_LIMIT: int = 5
#endregion

#region card
const GYRE_BEDROOM_STAMP_SIZE = 4
const GYRE_PARLOR_STAMP_SIZE = 4

const STAMP_SIZE: Vector2 = Vector2(144, 312)
const SHADOW_SIZE: Vector2 = Vector2(144, 80)
const STAMP_SIDE_HEIGHT: int = 40
const JOINT_SIZE = Vector2(36, 36)
const JOINT_OFFEST: float = -4.0
const STAKE_SIGN_OFFEST: float = 4.0
const STAMPS_LIMIT_FOR_RECRUITMENT = GYRE_BEDROOM_STAMP_SIZE * 2

const stakes = [Bozo.Stake.LEFT, Bozo.Stake.RIGHT]

const MARK_DIGITS_MAX_LENGTH: int = 6
const fusion_mark_lengths = [2, 3, 6]
#endregion

#region ladder
const LADDER_SIZE = Vector2i(5, 9) 
const STAIR_SIZE = Vector2(64, 64)
#endregion

const DEBT_MAX_AMOUNT: int = 100

const biomes = [Bozo.Biome.PLAIN, Bozo.Biome.SWAMP, Bozo.Biome.MOUNTAIN]

#region pie
const slice_volumes = [30, 20, 18, 12, 10, 6, 2, 4, 8, 32, 30, 20, 15, 10, 5, 25, 30, 18, 15, 12, 6, 3, 9, 27]
const slice_matters = [1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 3, 3, 3, 3, 3, 3, 2, 2, 2, 2, 2, 2, 2, 2]
const SLICE_INDEX_SHIFT = 8#10

const STARTER_HARVEST_AMOUNT: int = 40
const STARTER_PRIME_AMOUNT: int = 18
#endregion

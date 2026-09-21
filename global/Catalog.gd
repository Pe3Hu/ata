extends Node


#region dice
const orthogonal_directions = [Vector2i(1,0), Vector2i(0,1), Vector2i(-1,0), Vector2i(0,-1)]
const diagonal_directions = [Vector2i(1,-1), Vector2i(1,1), Vector2i(-1,1), Vector2i(-1,-1)]

const axes: Array[Vector3] = [
	Vector3(90, 0, 0),
	Vector3(0, 90, 0),
	Vector3(0, 0, 90)
]

const faces = [
	"front",
	"bottom",
	"left",
	"right",
	"top",
	"back",
]
#endregion

#region matter
const matters: Array[Bozo.Matter] = [
	Bozo.Matter.GAS,
	Bozo.Matter.LIQUID,
	Bozo.Matter.SOLID,
]
#endregion

#region canto
const tunes = [
	Bozo.Tune.INTRO,
	Bozo.Tune.VERSE,
	Bozo.Tune.OUTRO
]

const grids = [
	Vector2i(0, 0),
	Vector2i(0, 1),
	Vector2i(0, 2),
	Vector2i(1, 0),
	Vector2i(1, 1),
	Vector2i(1, 2),
]

const net_neighbors = {
	0: [3, 1, 2],
	1: [4, 2, 0],
	2: [5, 0, 1],
	3: [0, 4, 5],
	4: [1, 5, 3],
	5: [2, 3, 4]
}

const volumes = [2, 3, 4, 5, 6, 8, 9, 10, 12, 15, 18, 20, 25, 27, 30, 32]
const prime_volumes = [2, 3, 5]

const pulses = [0, 2, 3, 4, 5, 6, 8, 9, 10, 12, 15, 18, 20, 24, 25, 27, 30, 
		32, 36, 40, 45, 50, 54, 60, 64, 75, 81, 90, 96, 100]

const chorus_values = {
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

const CARD_APPEAR_DISTANCE = -1000
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
const LADDER_GRID = Vector2i(5, 9) 
const STAIR_SIZE = Vector2(48, 48) #64
const STEPLADDER_SIZE: Vector2 = Vector2(225, 415) #Vector2(290, 550)
const STEPLADDER_OFFSET: Vector2 = Vector2(-300, 24)
#endregion

const biomes = [Bozo.Biome.PLAIN, Bozo.Biome.SWAMP, Bozo.Biome.MOUNTAIN]

#region pie
const slice_volumes = [30, 20, 18, 12, 10, 6, 2, 4, 8, 32, 30, 20, 15, 10, 5, 25, 30, 18, 15, 12, 6, 3, 9, 27]
const slice_matters = [1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 3, 3, 3, 3, 3, 3, 2, 2, 2, 2, 2, 2, 2, 2]
const SLICE_INDEX_SHIFT = 8#10

const STARTER_HARVEST_AMOUNT: int = 40
const STARTER_PRIME_AMOUNT: int = 18

const DEBT_MAX_AMOUNT: int = 100
#endregion

#region gang 
const OPPORTUNINITY_AMOUNT: int = 21

const IDEA_INTENTION_AMOUNT: int = 5
const INENTION_OFFSET: float = 48#48
const INENTION_SIZE: Vector2 = Vector2(48, 48)

const IDEA_OFFSET: float = 200
const IDEA_SIZE: Vector2 = Vector2(136, 136)#Vector2.ONE * INENTION_OFFSET * 2 + INENTION_SIZE
const IDEA_ROTATION_SPEED: float = 0.5

const AMBITION_RADIUS: float = 80 + IDEA_SIZE.x
const POTENTIAL_SIZE: Vector2 = Vector2(35, 35)
const AMBITION_CENTER: Vector2 = Vector2(1, 4)
const POTENTIAL_OFFSET: float = 4
#endregion

#region bank
const elements = [
	Bozo.Element.CLOUD,
	Bozo.Element.VAPOR,
	Bozo.Element.DUST,
	Bozo.Element.SAND,
	Bozo.Element.ICE,
	Bozo.Element.LAVA,
	Bozo.Element.CHAOS
]

const basic_elements = [
	Bozo.Element.CLOUD,
	Bozo.Element.VAPOR,
	Bozo.Element.DUST,
	Bozo.Element.SAND,
	Bozo.Element.ICE,
	Bozo.Element.LAVA,
]

const aspects = [
	Bozo.Aspect.STRENGTH,
	Bozo.Aspect.DEXTERITY,
	Bozo.Aspect.INTELLECT
]

const aspect_anchors = [
	Vector2i(0, 0),
	Vector2i(-1, 1),
	Vector2i(1, 1),
]

const element_anchors = [
	Vector2i(0, 2),
	Vector2i(-1, 3),
	Vector2i(1, 3),
	Vector2i(0, 4),
	Vector2i(-1, 5),
	Vector2i(1, 5),
	Vector2i(0, 6),
]

const methods = [
	Bozo.Method.KILL,
	Bozo.Method.BREAK,
	Bozo.Method.FIND,
	Bozo.Method.HACK,
	Bozo.Method.RAKE,
	Bozo.Method.STEAL,
	#Bozo.Method.RAKE,
	#Bozo.Method.HACK,
	#Bozo.Method.BREAK,
	#Bozo.Method.FIND,
	#Bozo.Method.KILL
	#Bozo.Method.STEAL,
]

const ELEMENT_IMPULSE_FACTOR: int = 1

const obstacles = [Bozo.Obstacle.LOCK, Bozo.Obstacle.WALL, Bozo.Obstacle.CUSTODIAN]
const AVG_OBSTACLE_DIFFICULTY: int = 23
const difficulty_shifts = [-3, -1, 1]
#endregion

#region maelstrom
const EDDY_SIZE: Vector2 = Vector2(48, 48)
const EDDY_RADIUS: float = 44
const SHARD_RADIUS: float = 56#38
const PRESSURE_SCALE: Vector2 = Vector2(1.25, 1.25)
#endregion

const DEFAULT_KITCHEN_LIMIT: int = 4
const ASTERISM_RAIDUS: float = 260
const ASTERISM_SIZE: Vector2 = Vector2(320, 320)

const REFUGE_GRID: Vector2i = Vector2i(118, 66)


#region mainland
const MAINLAND_MATRIX: Vector2i = Vector2i(7, 7)
const MAINLAND_COORD_SIZE: Vector2 = Vector2i(48, 48)
const MAINLAND_GRID_SIZE: Vector2i = Vector2i(28, 17)
const MAINLAND_MAX_COORD: Vector2i = Vector2i(28, 16)
const OCEAN_MIN_COORD: Vector2i = Vector2i(-2, -2)
const OCEAN_MAX_COORD: Vector2i = Vector2i(29, 17)

const wasteland_anchors: Array[Vector2i] = [
	Vector2i(12, 1),
	Vector2i(10, 1),
	Vector2i(8, 1),
]

const wasteland_pattern_coords: Array[Vector2i] = [
	Vector2i(0, 0),
	Vector2i(0, 1),
	Vector2i(1, 1),
	Vector2i(1, 0)
]

const structure_coords: Array[Vector2] = [
	Vector2(1, -1),
	Vector2(1, 1),
	Vector2(-1, 1),
	Vector2(-1, -1),
]
#endregion

const structures: Array[Bozo.Structure] = [
	
]

const large_sctructures = [Bozo.Structure.FORGE, Bozo.Structure.MINE, Bozo.Structure.ATELIER]
const matter_sctructures = [Bozo.Structure.THEATER, Bozo.Structure.WORKSHOP, Bozo.Structure.LIGHTHOUSE, Bozo.Structure.MINE]
const mixed_sctructures = [Bozo.Structure.ATELIER, Bozo.Structure.FORGE]
const single_sctructures = [Bozo.Structure.TAVERN, Bozo.Structure.OBSERVATORY]
const center_wasteland_indexs = [5, 12]#[4, 5, 12, 13]

const complexity_ranks = [
	[0, 0, 0],
	[0, 0, 1],
	[0, 1, 1],
	[1, 1, 1],
	[1, 1, 2],
	[1, 2, 2],
	[2, 2, 2, 2],
]

const complexity_amounts = [2, 4, 4, 3, 2, 2, 1]

var magistral_steps = [
	Vector2i(4, -2),
	Vector2i(2, 4),
]
const MAGISTRAL_EXCEPTION_INDEX: int = 13
const trods = [Bozo.Trod.PRIMARY, Bozo.Trod.SECONDARY, Bozo.Trod.TERTIARY]

const ROUTE_MAX_PATHS = 3
const ROUTE_MAX_ENUMERATED = 200

const TROD_FREQUENCY: float = 0.5
const TROD_SPEED: float = 3.0 
const TROD_SELECTED_FACTOR: float = 3

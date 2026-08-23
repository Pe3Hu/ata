extends Node


enum Matter {
	NONE = 0,
	GAS = 1,
	LIQUID = 2,
	SOLID = 3,
	ANY = 4,
}

enum Tune {
	NONE = 0,
	INTRO = 5,
	VERSE = 6,
	OUTRO = 7,
	HOOK = 8,
	CHORUS = 9,
	BRIDGE = 10,
}

enum Shape {
	NONE = 0,
	F = 11,
	I = 12,
	L = 13,
	N = 14,
	P = 15,
	T = 16,
	U = 17,
	V = 18,
	W = 19,
	X = 20,
	Y = 21,
	Z = 22,
}

enum Biome {
	NONE = 0,
	PLAIN = 23,
	SWAMP = 24,
	MOUNTAIN = 25,
}

enum Stake {
	NONE = 0,
	LEFT = 26,
	RIGHT = 27,
}

enum Room {
	NONE = 0,
	ATTIC = 28,
	PARLOR = 29,
	BEDROOM = 30,
	KITCHEN = 31,
	CELLAR = 32,
}

enum Math {
	NONE = 0,
	PLUS = 33,
	MINUS = 34,
	MULTIPLY = 35,
}

enum Evaluation {
	NONE = 0,
	BEST = 36,
	NORMAL = 37,
	WORST = 38,
}

enum Relic {
	NONE = 0,
	BREATH = 39,
	BLOOD = 40,
	BONE = 41,
}

enum Temperature {
	NONE = 0,
	CHILL = 42,
	HARMONY = 43,
	HEAT = 44,
}

enum Catastrophe {
	NONE = 0,
	STORM = 45,
	MIST = 46,
	TORNADO = 47,
	HABOOB = 48,
	BLIZZARD = 49,
	VOLCANO = 50,
}


enum Status {
	IDLE = 0,
	PLAYING_ANIMATION = 100,
	WAITING_FOR_TARGET = 101,
}

enum Action {
	NONE = 0,
	MOVE_CARD = 150,
	MOVE_ARK = 151,
}

enum Phase {
	NONE = 0,
	GROWTH = 200,
	DRAW = 201,
	DECISION = 202,
	STOCK = 203,
	DISCARD = 204,
	FUSION = 205,
	RECRUITMENT = 206,
}


#region string
enum Type {
	NONE = 0,
	MATTER = -1,
	TUNE = -2,
	SHAPE = -3,
	BIOME = -4,
	STAKE = -5,
	ROOM = -6,
	MATH = -7,
	EVALUATION = -8,
	RELIC = -9,
	TEMPERATURE = -10,
	CATASTROPHE = -12,
	
	ACTION = -100,
	PHASE = -200,
}

const type_to_index = {
	Type.NONE: 0,
	Type.MATTER: 1,
	Type.TUNE: 5,
	Type.SHAPE: 11,
	Type.BIOME: 23,
	Type.STAKE: 26,
	Type.ROOM: 28,
	Type.MATH: 33,
	Type.EVALUATION: 36,
	Type.RELIC: 39,
	Type.TEMPERATURE: 42,
	Type.CATASTROPHE: 45,
	
	Type.ACTION: 104,
	Type.PHASE: 200,
}

const type_to_enum = {
	Type.MATTER: Bozo.Matter,
	Type.TUNE: Bozo.Tune,
	Type.BIOME: Bozo.Biome,
	Type.STAKE: Bozo.Stake,
	Type.MATH: Bozo.Math,
	Type.EVALUATION : Bozo.Evaluation,
	
	Type.ACTION: Bozo.Action,
	Type.PHASE: Bozo.Phase,
}

func enum_to_string(type_: Variant, value_: int) -> String:
	var index = value_ - type_to_index[type_] + 1
	var enum_ = type_to_enum[type_]
	var key_name: String = enum_.keys()[index]
	
	if key_name:
		return key_name.to_lower()
	
	return "unknown"
#endregion

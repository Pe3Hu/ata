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

enum Element {
	NONE = 0,
	CLOUD = 45,
	VAPOR = 46,
	DUST = 47,
	SAND = 48,
	ICE = 49,
	LAVA = 50,
	CHAOS = 51,
}

enum Catastrophe {
	NONE = 0,
	STORM = 52,
	MIST = 53,
	TORNADO = 54,
	HABOOB = 55,
	BLIZZARD = 56,
	VOLCANO = 57,
	VOID = 58,
}

enum Aspect {
	NONE = 0,
	STRENGTH = 59,
	DEXTERITY = 60,
	INTELLECT = 61,
}

enum Obstacle {
	NONE = 0,
	LOCK = 62,
	WALL = 63,
	CUSTODIAN = 64,
}

enum Mandate {
	NONE = 0,
	PASSWORD = 65,
	OUTLET = 66,
	KEY = 67,
}

enum Method {
	NONE = 0,
	RAKE = 68,
	HACK = 69,
	BREAK = 70,
	FIND = 71,
	KILL = 72,
	STEAL = 73,
}

enum Status {
	IDLE = 0,
	PLAYING_ANIMATION = 100,
	WAITING_FOR_TARGET = 101,
}

enum Action {
	NONE = 0,
	MOVE_CARD = 150,
	ATTACK_SHADOW = 151,
}

enum Phase {
	NONE = 0,
	GROWTH = 200,
	DRAW = 201,
	DECISION = 202,
	DISCARD = 203,
	FUSION = 204,
	PUNISHMENT = 205,
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
	ELENMENT = -12,
	CATASTROPHE = -13,
	ASPECT = -14, 
	OBSTACLE = -15,
	MANDATE = -16,
	METHOD = -17,
	
	
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
	Type.ELENMENT: 45,
	Type.CATASTROPHE: 52,
	Type.ASPECT: 59,
	Type.OBSTACLE: 62,
	Type.MANDATE: 65,
	Type.METHOD: 68,
	
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
	Type.ROOM: Bozo.Room,
	Type.ELENMENT: Bozo.Element,
	Type.CATASTROPHE: Bozo.Catastrophe,
	Type.ASPECT: Bozo.Aspect,
	Type.OBSTACLE: Bozo.Obstacle,
	Type.MANDATE: Bozo.Mandate,
	Type.METHOD: Bozo.Method,
	
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

extends Node


var tempo: int = 0
var is_auto_play: bool = false#true false
var is_pause: bool = false

const net_rolls: Array[float] = [0.1, 2]
const appears: Array[float] = [0.05, 0.8]
const activates: Array[float] = [0.05, 0.8]
#const peaks: Array[float] = [0.05, 0.8]
const jalousies: Array[float] = [0.2, 0.8]
const expands: Array[float] = [0.8, 0.8]
const cants: Array[float] = [0.4, 0.4]
const flips: Array[float] = [0.4, 0.4]


const min_appear_factor: float = -0.9#0.8
const max_appear_factor: float = -0.9#1.0

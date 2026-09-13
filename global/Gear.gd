extends Node


var tempo: int = 0
var is_auto_play: bool = true#true false
var is_pause: bool = false


const rolls: Array[float] = [0.06, 0.12, 0.25]
const appears: Array[float] = [0.2, 0.4, 0.8]
const activates: Array[float] = [0.2, 0.4, 0.8]
#const peaks: Array[float] = [0.05, 0.8]
const jalousies: Array[float] = [0.2, 0.4, 0.8]
const expands: Array[float] = [0.2, 0.4, 0.8]
const cants: Array[float] = [0.2, 0.4, 0.8]
const flips: Array[float] = [0.2, 0.4, 0.8]
const debts: Array[float] = [0.2, 0.4, 0.8]
const sorts: Array[float] = [0.2, 0.4, 0.8]
const bonds: Array[float] = [0.2, 0.4, 0.8]
const dissolves: Array[float] = [0.2, 0.4, 0.8]
const pressures: Array[float] = [0.2, 0.4, 0.8]




const min_appear_factor: float = -0.9#0.8
const max_appear_factor: float = -0.9#1.0

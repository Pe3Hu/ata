class_name RaidData
extends RefCounted


var gambit: GambitData
var cantos: Array[CantoData]

var overrun: int


#region init
func _init(gambit_: GambitData, cantos_: Array) -> void:
	gambit = gambit_
	cantos.append_array(cantos_)
	
	gambit.raids.append(self)
	calc_overrun()

func calc_overrun() -> void:
	overrun = 0
	
	for canto in cantos:
		overrun += canto.pulse_value
	
	#overrun -= bastion.current_rampart
#endregion

func launch() -> void:
	for canto in cantos:
		canto.voice()
	
	#gambit.warlord.faction.capture_bastion(bastion)

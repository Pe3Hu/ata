class_name AnvilData
extends RefCounted


var arsenal: ArsenalData
var echos: Array[EchoData]

var new_echo: EchoData


#region init
func _init(arsenal_: ArsenalData, echos_: Array) -> void:
	arsenal = arsenal_
	echos.append_array(echos_)
	
	arsenal.anvils.append(self)
	init_new_echo()

func init_new_echo() -> void:
	var intro_values: Array[int]
	var verse_values: Array[int]
	var letters = []
	
	for echo in echos:
		for stake in echo.tune_to_stakes[Bozo.Tune.INTRO]:
			intro_values.append(stake.value)
		
		for stake in echo.tune_to_stakes[Bozo.Tune.VERSE]:
			verse_values.append(stake.value)
		
		for letter in echo.mark_digits.split(""):
			if not letters.has(letter):
				letters.append(letter)
	
	intro_values.sort()
	intro_values.reverse()
	
	var origin = echos.front().origin
	new_echo = EchoData.new(origin, intro_values, verse_values)
	
	letters.sort()
	var str_mark = ""
	
	for mark in letters:
		str_mark += mark
	
	new_echo.mark_digits = str_mark
#endregion

func fusion() -> void:
	var origin = echos.front().origin
	
	for echo in echos:
		origin.echos.erase(echo)
		origin.atheneum.house.cellar.echos.erase(echo)
	
	origin.echos.append(new_echo)
	origin.atheneum.house.cellar.echos.append(new_echo)
	Arbitrator.current_phase.exit_phase()

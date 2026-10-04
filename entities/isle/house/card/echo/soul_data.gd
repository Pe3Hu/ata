class_name SoulData
extends RefCounted


var master: MasterData
var task: TaskData
var matter: Bozo.Matter

var intro: DiceData
var reincarnation_intro: DiceData
var verse: DiceData

var echos: Array[EchoData]

var rank: Bozo.Rank
var talent: int
var name: String


#region init
func _init(master_: MasterData, matter_: Bozo.Matter, intro_: DiceData, verse_: DiceData, talent_: int, name_: String = '') -> void:
	master = master_
	matter = matter_
	intro = intro_
	verse = verse_
	talent = talent_
	name = name_
	rank = Digest.intro_to_talent_to_rank[intro.get_sum()][talent]
	reincarnation_intro = Helper.roll_reincarnation(self)
	
	if name == '':
		name = master.guild.roll_name()
		
		if master.guild.alphabet.is_empty():
			master.guild.refill_alphabet()
	
	init_echos()

func init_echos() -> void:
	var intro_indexs = []
	intro_indexs.assign(range(6))
	var verse_indexs = []
	verse_indexs.assign(range(6))
	intro_indexs.shuffle()
	verse_indexs.shuffle()
	var l = 1
	@warning_ignore("integer_division")
	var n = intro_indexs.size() / l
	
	intro_indexs.sort()
	intro_indexs.reverse()
	
	for _i in n:
		var intro_values: Array[int]
		var verse_values: Array[int] 
		
		for _j in l:
			var index = intro_indexs.pop_back()
			intro_values.append(intro.values[index])
			index = verse_indexs.pop_back()
			verse_values.append(verse.values[index])
		
		add_echo(intro_values, verse_values)

func add_echo(intro_values_: Array[int], verse_values_: Array[int]) -> void:
	var echo = EchoData.new(self, intro_values_, verse_values_)
	echos.append(echo)
	
	if master is BarkeeperData:
		Mother.house.attic.echos.append(echo)
	
	var str_mark = ""
	
	for _i in intro_values_.size():
		var digit = echos.size() + _i
		str_mark += str(digit)
	
	echo.mark_digits = str_mark
#endregion

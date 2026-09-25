class_name OriginData
extends RefCounted


var master: MasterData
var matter: Bozo.Matter

var intro: DiceData
var verse: DiceData

var stamps: Array[StampData]

var rank: Bozo.Rank
var talent: int
var mark_letter: String


#region init
func _init(master_: MasterData, matter_: Bozo.Matter, intro_: DiceData, verse_: DiceData, talent_: int = 3) -> void:
	master = master_
	matter = matter_
	intro = intro_
	verse = verse_
	talent = talent_
	rank = Digest.intro_to_talent_to_rank[intro.get_sum()][talent]
	
	if master as BarkeeperData:
		mark_letter = master.alphabet.pop_back()
		
		if master.alphabet.is_empty():
			master.refill_alphabet()
	
	init_stamps()

func init_stamps() -> void:
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
		
		add_stamp(intro_values, verse_values)

func add_stamp(intro_values_: Array[int], verse_values_: Array[int]) -> void:
	var stamp = StampData.new(self, intro_values_, verse_values_)
	stamps.append(stamp)
	
	if master is BarkeeperData:
		Mother.house.attic.stamps.append(stamp)
	
	var str_mark = ""
	
	for _i in intro_values_.size():
		var digit = stamps.size() + _i
		str_mark += str(digit)
	
	stamp.mark_digits = str_mark
#endregion

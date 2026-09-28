class_name InstrumentData
extends TaskData


var verse: VerseDiceData

var razors: Array[RazorData]


func _init(master_: MasterData, rank_: int, verse_index: int) -> void:
	super._init(master_, rank_)
	verse = load('res://entities/dice/datas/verse/%d.tres' % verse_index)
	
	init_razor()

func init_razor() -> void:
	for volume in verse.values:
		var _razor = RazorData.new(self, volume)

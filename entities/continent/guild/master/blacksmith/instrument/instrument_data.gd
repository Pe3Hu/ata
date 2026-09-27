class_name InstrumentData
extends TaskData


var master: MasterData
var rank: int
var verse: VerseDiceData

var razors: Array[RazorData]
var tribute: TributeData


func _init(master_: MasterData, rank_: int, verse_index: int) -> void:
	master = master_
	rank = rank_
	verse = load('res://entities/dice/datas/verse/%d.tres' % verse_index)
	
	master.tasks.append(self)
	
	init_tribute()
	init_razor()

func init_tribute() -> void:
	var price = Digest.master_to_price[master.type] * rank
	var volumes = Digest.master_to_volumes[master.type]
	tribute = TributeData.new(price, volumes)

func init_razor() -> void:
	for volume in verse.values:
		var _razor = RazorData.new(self, volume)

class_name InstrumentData
extends RefCounted


var blacksmith: BlacksmithData
var rank: int
var verse: VerseDiceData

var razors: Array[RazorData]
var tribute: TributeData


func _init(blacksmith_: BlacksmithData, rank_: int, verse_index: int) -> void:
	blacksmith = blacksmith_
	rank = rank_
	verse = load('res://entities/dice/datas/verse/%d.tres' % verse_index)
	
	blacksmith.instruments.append(self)
	
	init_tribute()
	init_razor()

func init_tribute() -> void:
	var price = Digest.master_to_price[blacksmith.type] * rank
	var volumes = Digest.master_to_volumes[blacksmith.type]
	tribute = TributeData.new(price, volumes)

func init_razor() -> void:
	for volume in verse.values:
		var _razor = RazorData.new(self, volume)

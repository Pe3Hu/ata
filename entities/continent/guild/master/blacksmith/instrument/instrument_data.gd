class_name InstrumentData
extends TaskData


var verse: VerseDiceData

var razors: Array[RazorData]


func _init(master_: MasterData, order_: int, verse_index: int) -> void:
	super._init(master_, order_)
	verse = load('res://entities/dice/datas/verse/%d.tres' % verse_index)
	
	init_razors()

func init_razors() -> void:
	for volume in verse.values:
		var razor = RazorData.new(volume, master.guild.structure.matters)
		razors.append(razor)

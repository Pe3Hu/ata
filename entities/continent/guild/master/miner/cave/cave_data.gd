class_name CaveData
extends TaskData


var master: MasterData
var rank: int

var lode: LodeData
var tribute: TributeData


func _init(master_: MasterData, rank_: int) -> void:
	master = master_
	rank = rank_
	
	master.tasks.append(self)
	
	lode = LodeData.new(self)
	init_tribute()

func init_tribute() -> void:
	var price = Digest.master_to_price[master.type] * rank
	var volumes = Digest.master_to_volumes[master.type]
	tribute = TributeData.new(price, volumes)

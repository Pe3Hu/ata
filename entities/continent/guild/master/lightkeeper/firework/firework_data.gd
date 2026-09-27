class_name FireworkData
extends TaskData


var master: MasterData
var rank: int

var tribute: TributeData


func _init(master_: MasterData, rank_: int) -> void:
	master = master_
	rank = rank_
	
	master.tasks.append(self)
	
	init_tribute()

func init_tribute() -> void:
	var price = Digest.master_to_price[master.type] * rank
	var volumes = Digest.master_to_volumes[master.type]
	tribute = TributeData.new(price, volumes)

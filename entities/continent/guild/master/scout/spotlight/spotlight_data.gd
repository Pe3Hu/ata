class_name SpotlightData
extends TaskData


var master: MasterData
var shelter: ShelterData
var rank: int

var tribute: TributeData


func _init(master_: MasterData, shelter_: ShelterData) -> void:
	master = master_
	shelter = shelter_
	rank = 1
	
	master.tasks.append(self)
	
	init_tribute()

func init_tribute() -> void:
	var price = Digest.master_to_price[master.type] * rank
	var volumes = Digest.master_to_volumes[master.type]
	tribute = TributeData.new(price, volumes)

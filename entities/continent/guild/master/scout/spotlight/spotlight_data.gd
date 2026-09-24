class_name SpotlightData
extends RefCounted


var scout: ScoutData
var shelter: ShelterData
var rank: int

var tribute: TributeData


func _init(scout_: ScoutData, shelter_: ShelterData) -> void:
	scout = scout_
	shelter = shelter_
	rank = 1
	
	scout.spotlights.append(self)
	
	init_tribute()

func init_tribute() -> void:
	var price = Digest.master_to_price[scout.type] * rank
	var volumes = Digest.master_to_volumes[scout.type]
	tribute = TributeData.new(price, volumes)

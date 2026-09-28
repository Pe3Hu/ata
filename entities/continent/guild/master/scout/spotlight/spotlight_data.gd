class_name SpotlightData
extends TaskData


var shelter: ShelterData


func _init(master_: MasterData, rank_: int, shelter_: ShelterData) -> void:
	super._init(master_, rank_)
	shelter = shelter_

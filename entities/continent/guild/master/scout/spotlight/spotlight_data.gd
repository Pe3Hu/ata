class_name SpotlightData
extends TaskData


var shelter: ShelterData


func _init(master_: MasterData, order_: int, shelter_: ShelterData) -> void:
	super._init(master_, order_)
	shelter = shelter_

func _on_finished() -> void:
	Mother.mainland.beam.activate()
	super._on_finished()

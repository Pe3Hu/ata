class_name SculptureData
extends TaskData


var asterism: AsterismData


func _init(master_: MasterData, rank_: int, asterism_: AsterismData) -> void:
	super._init(master_, rank_)
	asterism = asterism_

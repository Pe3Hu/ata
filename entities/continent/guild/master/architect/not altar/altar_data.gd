class_name NotAltarData
extends TaskData


var asterism: AsterismData


func _init(master_: MasterData, rank_: int, asterism_: AsterismData) -> void:
	super._init(master_, rank_)
	asterism = asterism_

func _on_finished() -> void:
	build_altar()
	super._on_finished()

func build_altar() -> void:
	pass

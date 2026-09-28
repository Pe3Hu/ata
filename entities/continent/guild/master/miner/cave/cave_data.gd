class_name CaveData
extends TaskData


var lode: LodeData


func _init(master_: MasterData, rank_: int) -> void:
	super._init(master_, rank_)
	lode = LodeData.new(self)

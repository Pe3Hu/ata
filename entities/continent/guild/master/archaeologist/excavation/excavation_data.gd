class_name ExcavationData
extends TaskData


var ruin: RuinData


func _init(master_: MasterData, order_: int) -> void:
	super._init(master_, order_)
	ruin = master_.guild.structure

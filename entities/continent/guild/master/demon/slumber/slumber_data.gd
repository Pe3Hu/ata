class_name SlumberData
extends TaskData


var rift: RiftData


func _init(master_: MasterData, order_: int) -> void:
	super._init(master_, order_)
	rift = master_.guild.structure

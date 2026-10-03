class_name MinerData
extends MasterData


func init_tasks() -> void:
	for order in Digest.master_to_order[type]:
		CaveData.new(self, order)

class_name MinerData
extends MasterData



func init_tasks() -> void:
	tasks.clear()
	
	for rank in Digest.master_to_rank[type]:
		CaveData.new(self, rank + 1)
	
	current_task = tasks.front()

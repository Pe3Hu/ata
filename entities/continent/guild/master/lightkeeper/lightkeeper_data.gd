class_name LightkeeperData
extends MasterData


func init_static_tasks() -> void:
	for rank in Digest.master_to_rank[type]:
		FireworkData.new(self, rank)
	
	current_task = tasks.front()

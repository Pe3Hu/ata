class_name LightkeeperData
extends MasterData


func init_static_tasks() -> void:
	for order in Digest.master_to_order[type]:
		FireworkData.new(self, order)
	
	current_task = tasks.front()

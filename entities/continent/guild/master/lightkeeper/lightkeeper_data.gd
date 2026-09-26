class_name LightkeeperData
extends MasterData



func _init(guild_: GuildData) -> void:
	super._init(guild_)
	
	type = Bozo.Master.LIGHTKEEPER
	init_tasks()

func init_tasks() -> void:
	for rank in Digest.master_to_rank[type]:
		FireworkData.new(self, rank + 1)
	
	current_task = tasks.front()

class_name LightkeeperData
extends MasterData


signal firework_changed

var fireworks: Array[FireworkData]

var current_firework: FireworkData:
	set(value_):
		current_firework = value_
		firework_changed.emit()


func _init(guild_: GuildData) -> void:
	super._init(guild_)
	
	type = Bozo.Master.LIGHTKEEPER
	init_fireworks()

func init_fireworks() -> void:
	for rank in Digest.master_to_rank[type]:
		var _firework = FireworkData.new(self, rank + 1)
	
	current_firework = fireworks.front()

func changed_firework(shift_: int) -> void:
	var index = fireworks.find(current_firework)
	var n = fireworks.size()
	index = (index + shift_ + n) % n
	current_firework = fireworks[index]

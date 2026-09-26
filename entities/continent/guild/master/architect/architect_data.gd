class_name ArchitectData
extends MasterData



func _init(guild_: GuildData) -> void:
	super._init(guild_)
	
	tasks.append_array(Mother.welkin.asterisms)
	current_task = tasks.front()

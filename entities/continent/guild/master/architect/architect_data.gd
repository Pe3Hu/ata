class_name ArchitectData
extends MasterData


signal asterism_changed

var current_asterism: AsterismData:
	set(value_):
		current_asterism = value_
		asterism_changed.emit()


func _init(guild_: GuildData) -> void:
	super._init(guild_)
	current_asterism = Mother.welkin.asterisms.front()

func changed_asterism(shift_: int) -> void:
	var index = Mother.welkin.asterisms.find(current_asterism)
	var n = Mother.welkin.asterisms.size()
	index = (index + shift_ + n) % n
	current_asterism = Mother.welkin.asterisms[index]

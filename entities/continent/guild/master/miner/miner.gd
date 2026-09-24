class_name Miner
extends Master


func _ready() -> void:
	data = Mother.guild.miner
	super._ready()
	%Cave.data = data.current_cave

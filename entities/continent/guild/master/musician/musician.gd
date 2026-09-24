class_name Musician
extends Master


func _ready() -> void:
	data = Mother.guild.musician
	super._ready()
	%Veteran.data = data.current_veteran

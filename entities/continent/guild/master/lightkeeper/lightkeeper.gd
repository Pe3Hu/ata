class_name Lightkeeper
extends Master


func _ready() -> void:
	data = Mother.guild.lightkeeper
	super._ready()
	%Firework.data = data.current_firework

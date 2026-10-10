class_name Demon
extends Master


func _ready() -> void:
	data = Mother.guild.demon
	super._ready()
	%Slumber.data = data.current_task

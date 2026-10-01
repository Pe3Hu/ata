class_name Architect
extends Master



func _ready() -> void:
	data = Mother.guild.architect
	super._ready()
	%Sculpture.data = data.current_task

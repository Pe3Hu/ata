class_name Tailor
extends Master


func _ready() -> void:
	data = Mother.guild.tailor
	super._ready()
	%Attire.data = data.current_attire

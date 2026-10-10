class_name Archaeologist
extends Master


func _ready() -> void:
	data = Mother.guild.archaeologist
	super._ready()
	%Excavation.data = data.current_task

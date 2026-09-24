class_name Barkeeper
extends Master


func _ready() -> void:
	data = Mother.guild.barkeeper
	super._ready()
	%Recruit.data = data.current_recruit

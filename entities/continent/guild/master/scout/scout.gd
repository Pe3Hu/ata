class_name Scout
extends Master


func _ready() -> void:
	data = Mother.guild.scout
	super._ready()
	%Spotlight.scout = self
	%Spotlight.data = data.current_spotlight

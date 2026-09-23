class_name Blacksmith
extends Master



func _ready() -> void:
	data = Mother.guild.blacksmith
	super._ready()
	%Instrument.data = data.current_instrument

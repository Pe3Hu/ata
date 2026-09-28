class_name Architect
extends Master



func _ready() -> void:
	data = Mother.guild.architect
	super._ready()
	%Sculpture.data = data.current_task



#
#func _on_previous_button_pressed() -> void:
	#data.changed_task(-1)
#
#func _on_next_button_pressed() -> void:
	#data.changed_task(1)

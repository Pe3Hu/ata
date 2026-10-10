class_name Slumber
extends Task


func connect_signals() -> void:
	super.connect_signals()
	%Gloom.value.text = str(data.rift.limit_gloom)

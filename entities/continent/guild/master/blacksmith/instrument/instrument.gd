class_name Instrument
extends Task


var razor_scene = preload('uid://2smcb1akyroc')


func connect_signals() -> void:
	super.connect_signals()
	init_razors()

func init_razors() -> void:
	Helper.clear_children(%Razors)
	
	for razor_data in data.razors:
		add_razor(razor_data)

func add_razor(razor_data_: RazorData) -> void:
	var razor = razor_scene.instantiate()
	%Razors.add_child(razor)
	razor.data = razor_data_

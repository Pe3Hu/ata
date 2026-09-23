class_name Isle
extends Control


var data: IsleData:
	set(value_):
		data = value_
		connect_datas()

@export var kernel: Kernel
@export var house: House
@export var odeum: Odeum

@export var arsenal: Arsenal

@export var misson: Mission
@export var welkin: Welkin


func _ready() -> void:
	data = Mother.isle
	
	if Arbitrator.is_gameover:
		Arbitrator.is_gameover = false
		Arbitrator.start_new_round()

func connect_datas() -> void:
	#kernel.data = data.kernel
	house.data = data.atheneum.house
	odeum.data = data.odeum
	arsenal.data = data.arsenal
	
	misson.data = data.mission
	#welkin.data = data.welkin

func _input(event) -> void:
	if event is InputEventKey and event.pressed and not event.echo:
		match event.keycode:
			KEY_ESCAPE:
				get_tree().quit()
			KEY_SPACE:
				Arbitrator.skip_phase()

class_name Isle
extends Control


@export var kernel: Kernel
@export var house: House
@export var odeum: Odeum

@export var arsenal: Arsenal

@export var misson: Mission
@export var welkin: Welkin


func _ready() -> void:
	connect_datas()
	
	if Arbitrator.is_gameover:
		Arbitrator.is_gameover = false
		Arbitrator.start_new_round()

func connect_datas() -> void:
	#kernel.data = Mother.kernel
	house.data = Mother.house
	odeum.data = Mother.odeum
	arsenal.data = Mother.arsenal
	
	misson.data = Mother.mission
	#welkin.data = Mother.welkin

func _input(event) -> void:
	if event is InputEventKey and event.pressed and not event.echo:
		match event.keycode:
			KEY_ESCAPE:
				get_tree().quit()
			KEY_SPACE:
				Arbitrator.skip_phase()

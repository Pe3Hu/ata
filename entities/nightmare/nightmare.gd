class_name Nightmare
extends Control


var data: NightmareData

@export var kernel: Kernel
@export var house: House
@export var odeum: Odeum

@export var arsenal: Arsenal


func _ready() -> void:
	connect_datas()
	
	if Arbitrator.is_gameover:
		Arbitrator.is_gameover = false
		Arbitrator.start_new_round()

func connect_datas() -> void:
	data = Mother.nightmare
	kernel.data = Mother.kernel
	house.data = Mother.house
	odeum.data = Mother.odeum
	arsenal.data = Mother.arsenal

func _input(event) -> void:
	if event is InputEventKey and event.pressed and not event.echo:
		match event.keycode:
			KEY_ESCAPE:
				get_tree().quit()
			KEY_SPACE:
				Arbitrator.skip_phase()

class_name Nightmare
extends Control


var data: NightmareData

@export var kernel: Kernel
@export var house: House
@export var odeum: Odeum

@export var arsenal: Arsenal
@export var gloom: Gloom


func _ready() -> void:
	connect_datas()
	connect_signals()
	
	Arbitrator.start_new_round()

func connect_datas() -> void:
	data = Mother.nightmare
	kernel.data = Mother.kernel
	house.data = Mother.house
	odeum.data = Mother.odeum
	arsenal.data = Mother.arsenal
	
	gloom.data = Mother.nightmare.slumber.rift.gloom

func connect_signals() -> void:
	data.admit_defeat.connect(_on_defeat)

func _on_defeat() -> void:
	odeum.visible = false
	
	for card in house.parlor.cards:
		card.reset()

func _input(event) -> void:
	if event is InputEventKey and event.pressed and not event.echo:
		match event.keycode:
			KEY_ESCAPE:
				get_tree().quit()
			KEY_SPACE:
				Arbitrator.skip_phase()

class_name Isle
extends Control


var data: IsleData:
	set(value_):
		data = value_
		connect_datas()

@export var kernel: Kernel
@export var house: House
@export var odeum: Odeum

@export var stepladder: Stepladder
@export var forge: Forge

@export var misson: Mission


func _ready() -> void:
	data = IsleData.new()
	Arbitrator.start_new_round()

func connect_datas() -> void:
	kernel.data = data.kernel
	house.data = data.atheneum.house
	odeum.data = data.odeum
	misson.data = data.mission

func _input(event) -> void:
	if event is InputEventKey and event.pressed and not event.echo:
		match event.keycode:
			KEY_ESCAPE:
				get_tree().quit()
			KEY_SPACE:
				Arbitrator.apply_pass()

class_name Kernel
extends PanelContainer


@export var volume_scene = preload("uid://dpvkcodr3cjop")

var data: KernelData

@export var usurer: Usurer
@export var pie: Pie
@export var maelstrom: Maelstrom

@export var stepladder: Stepladder


func _ready() -> void:
	data = Mother.kernel
	
	connect_datas()

func connect_datas() -> void:
	usurer.data = data.usurer
	pie.data = data.pie
	maelstrom.data = data.maelstrom
	stepladder.data = data.stepladder

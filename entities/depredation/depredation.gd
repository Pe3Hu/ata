class_name Depredation
extends Control


var data: DepredationData:
	set(value_):
		data = value_
		
		connect_data()
		connect_signals()

@export var bank: Bank
@export var gang: Gang
@export var loot: Loot


func _ready() -> void:
	data = Mother.depredation

func connect_signals() -> void:
	data.obstacle_cleared.connect(_on_obstacle_cleared)

func _on_obstacle_cleared(_obstacle_data_) -> void:
	%HBoxStart.visible = false
	%VBoxEnd.visible = true

func connect_data() -> void:
	bank.data = data.bank
	gang.data = data.gang
	loot.data = data.bank.ruin.loot

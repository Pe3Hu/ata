class_name Depredation
extends Control


var data: DepredationData:
	set(value_):
		data = value_
		
		connect_data()

@export var bank: Bank
@export var gang: Gang
#@export var loot: Loot


func _ready() -> void:
	data = Mother.depredation

func connect_data() -> void:
	bank.data = data.bank
	gang.data = data.gang
	#loot.data = data.loot

class_name Mission
extends PanelContainer


var data: MissionData:
	set(value_):
		data = value_
		
		connect_data()

@export var bank: Bank
@export var gang: Gang
@export var loot: Loot


func connect_data() -> void:
	bank.data = data.bank
	gang.data = data.gang
	loot.data = data.loot

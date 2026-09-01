class_name MissionData
extends RefCounted


var isle: IsleData

var bank: BankData


func _init(isle_: IsleData) -> void:
	isle = isle_
	
	bank = BankData.new(self)

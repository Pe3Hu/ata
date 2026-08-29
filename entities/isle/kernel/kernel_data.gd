class_name KernelData
extends RefCounted


var faction: FactionData

var usurer: UsurerData
var pie: PieData


func _init(faction_: FactionData) -> void:
	faction = faction_
	
	usurer = UsurerData.new(self)
	pie = PieData.new(self)

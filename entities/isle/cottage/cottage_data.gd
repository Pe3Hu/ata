class_name CottageData
extends RefCounted


var attic: ChamberData = ChamberData.new(self, Bozo.Room.ATTIC)
var kitchen: ChamberData = ChamberData.new(self, Bozo.Room.KITCHEN)
var cellar: ChamberData = ChamberData.new(self, Bozo.Room.CELLAR)

var chambers: Array[ChamberData]
var type_to_chamber: Dictionary


#region init
func _init() -> void:
	update_chamber_fol()
	update_chamber_ere()
	
	chambers = [
		attic,
		kitchen,
		cellar,
	]
	
	type_to_chamber[Bozo.Room.ATTIC] = attic
	type_to_chamber[Bozo.Room.KITCHEN] = kitchen
	type_to_chamber[Bozo.Room.CELLAR] = cellar

func update_chamber_fol() -> void:
	attic.fol = kitchen
	kitchen.fol = cellar
	cellar.fol = attic

func update_chamber_ere() -> void:
	attic.ere = cellar
	kitchen.ere = attic
	cellar.ere = kitchen

func reset() -> void:
	for chamber in chambers:
		chamber.ideas.clear()
#endregion

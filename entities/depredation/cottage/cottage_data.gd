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
	
	init_ideas()

func update_chamber_fol() -> void:
	attic.fol = kitchen
	kitchen.fol = cellar
	cellar.fol = attic

func update_chamber_ere() -> void:
	attic.ere = cellar
	kitchen.ere = attic
	cellar.ere = kitchen

func init_ideas() -> void:
	for _i in Catalog.OPPORTUNINITY_AMOUNT:
		IdeaData.new(self, _i + 1)
	
	attic.ideas.shuffle()

func refill_kitchen() -> void:
	if attic.ideas.is_empty():
		attic.ere.clear()
		attic.ideas.shuffle()
	
	var n = Digest.ruin_to_ideas[Mother.depredation.bank.ruin.order]
	
	while kitchen.ideas.size() < n:
		attic.transfer_random_idea()

func reset() -> void:
	for chamber in chambers:
		chamber.ideas.clear()
#endregion

class_name AttireData
extends RefCounted


signal spoil_changed

var tailor: TailorData
var rank: int

var tributes: Array[TributeData]
var spoils: Array[SpoilData]

var current_spoil: SpoilData:
	set(value_):
		current_spoil = value_
		spoil_changed.emit()


func _init(tailor_: TailorData, rank_: int) -> void:
	tailor = tailor_
	rank = rank_
	
	tailor.attires.append(self)
	init_tribute()
	init_spoils()

func init_tribute() -> void:
	tributes.clear()
	var matters = tailor.guild.structure.matters
	var volume = Digest.matter_to_matter_to_volume[matters.front()][matters.back()]
	
	for matter in matters:
		var volumes = [volume]
		var price = volume * (rank * 2 - 1)
		var _tribute = TributeData.new(price, volumes)
		tributes.append(_tribute)
		_tribute.quotums = _tribute.quotums.filter(func (a): return a.shard.matter == matter)
		_tribute.current_quotum = _tribute.quotums.front()

func init_spoils() -> void:
	spoils.clear()
	var matters = tailor.guild.structure.matters
	var volume = Digest.matter_to_matter_to_volume[matters.front()][matters.back()] * 2
	var amount = rank * 2 - 1
	
	for matter in matters:
		var spoil = SpoilData.new(matter, volume, amount)
		spoils.append(spoil)
	
	current_spoil = spoils.front()

func changed_spoil(shift_: int) -> void:
	var index = spoils.find(current_spoil)
	var n = spoils.size()
	index = (index + shift_ + n) % n
	current_spoil = spoils[index]
	tailor.sync_spoil(self)

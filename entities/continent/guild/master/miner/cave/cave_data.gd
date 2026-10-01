class_name CaveData
extends TaskData


var lode: LodeData


func _init(master_: MasterData, rank_: int) -> void:
	super._init(master_, rank_)
	lode = LodeData.new(self)

func _on_finished() -> void:
	extract()
	super._on_finished()

func extract() -> void:
	lode.fill_spoils()
	
	for spoil in lode.spoils:
		Mother.kernel.pie.plus_spoil(spoil)

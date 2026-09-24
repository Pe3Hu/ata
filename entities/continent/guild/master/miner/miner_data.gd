class_name MinerData
extends MasterData


signal cave_changed

var caves: Array[CaveData]

var current_cave: CaveData:
	set(value_):
		current_cave = value_
		cave_changed.emit()


func init_caves() -> void:
	caves.clear()
	
	for rank in Digest.master_to_rank[type]:
		var _cave = CaveData.new(self, rank + 1)
	
	current_cave = caves.front()

func changed_cave(shift_: int) -> void:
	var index = caves.find(current_cave)
	var n = caves.size()
	index = (index + shift_ + n) % n
	current_cave = caves[index]

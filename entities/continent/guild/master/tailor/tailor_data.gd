class_name TailorData
extends MasterData


signal attire_changed

var attires: Array[AttireData]

var current_attire: AttireData:
	set(value_):
		current_attire = value_
		attire_changed.emit()


func init_attires() -> void:
	attires.clear()
	
	for rank in Digest.master_to_rank[type]:
		AttireData.new(self, rank + 1)
	
	current_attire = attires.front()

func changed_attire(shift_: int) -> void:
	var index = attires.find(current_attire)
	var n = attires.size()
	index = (index + shift_ + n) % n
	current_attire = attires[index]

func sync_spoil(source_: AttireData) -> void:
	var matter = source_.current_spoil.shard.matter
	
	for attire in attires:
		if attire == source_: continue
		
		for spoil in attire.spoils:
			if spoil.shard.matter == matter:
				attire.current_spoil = spoil
				break

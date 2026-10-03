class_name TailorData
extends MasterData


func init_tasks() -> void:
	for order in Digest.master_to_order[type]:
		AttireData.new(self, order)

func sync_spoil(source_: AttireData) -> void:
	var matter = source_.current_spoil.shard.matter
	
	for attire in tasks:
		if attire == source_: continue
		
		for spoil in attire.spoils:
			if spoil.shard.matter == matter:
				attire.current_spoil = spoil
				break

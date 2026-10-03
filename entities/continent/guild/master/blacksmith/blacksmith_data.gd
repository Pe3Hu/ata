class_name BlacksmithData
extends MasterData


func init_tasks() -> void:
	#if guild.structure.type == Digest.master_to_structure[type]:
	for order in Digest.order_to_matter_to_matter_to_vesre:
		var verse_index = Digest.order_to_matter_to_matter_to_vesre[order][guild.structure.matters.front()][guild.structure.matters.back()]
		InstrumentData.new(self, order, verse_index)

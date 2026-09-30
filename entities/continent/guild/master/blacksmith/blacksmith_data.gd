class_name BlacksmithData
extends MasterData



func init_tasks() -> void:
	#if guild.structure.type == Digest.master_to_structure[type]:
	for rank in Digest.rank_to_matter_to_matter_to_vesre:
		var verse_index = Digest.rank_to_matter_to_matter_to_vesre[rank][guild.structure.matters.front()][guild.structure.matters.back()]
		InstrumentData.new(self, rank, verse_index)

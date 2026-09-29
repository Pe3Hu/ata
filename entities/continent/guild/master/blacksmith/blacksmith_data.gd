class_name BlacksmithData
extends MasterData



func init_tasks() -> void:
	for rank in Digest.rank_to_matter_to_matter_to_vesre:
		var verse_index = Digest.rank_to_matter_to_matter_to_vesre[rank][guild.structure.matters.front()][guild.structure.matters.back()]
		InstrumentData.new(self, rank, verse_index)

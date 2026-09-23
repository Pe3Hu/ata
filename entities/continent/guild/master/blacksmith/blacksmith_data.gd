class_name BlacksmithData
extends MasterData


signal instrument_changed

var instruments: Array[InstrumentData]

var current_instrument: InstrumentData:
	set(value_):
		current_instrument = value_
		instrument_changed.emit()


func init_instruments() -> void:
	instruments.clear()
	
	for rank in Digest.rank_to_matter_to_matter_to_vesre:
		var verse_index = Digest.rank_to_matter_to_matter_to_vesre[rank][guild.structure.matters.front()][guild.structure.matters.back()]
		var _instrument = InstrumentData.new(self, rank, verse_index)
	
	current_instrument = instruments.front()

func changed_instrument(shift_: int) -> void:
	var index = instruments.find(current_instrument)
	var n = instruments.size()
	index = (index + shift_ + n) % n
	current_instrument = instruments[index]

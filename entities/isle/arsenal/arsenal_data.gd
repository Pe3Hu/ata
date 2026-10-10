class_name ArsenalData
extends RefCounted


signal fusion_phase
@warning_ignore("unused_signal")
signal phase_finished

var anvils: Array[AnvilData]
var echos: Array[EchoData]
	#set(value_):
		#echos = value_
		#init_anvils()

var biome_to_source: Dictionary


#region init
func _init() -> void:
	init_sources()

func init_anvils() -> void:
	anvils.clear()
	var sizes = [3, 2]
	
	for size in sizes:
		var arrangements = Helper.generate_unique_arrangements_fixed_size(echos, size)
		
		for arrangement in arrangements:
			if is_echos_has_same_soul(arrangement):
				if try_fuse_echos(arrangement):
					AnvilData.new(self, arrangement)
	
	fusion_phase.emit()

func is_echos_has_same_soul(echos_: Array) -> bool:
	for echo in echos_:
		if echo.soul != echos_.front().soul:
			return false
	
	return true

func try_fuse_echos(echos_: Array) -> bool:
	var digits_length = 0
	
	for echo in echos_:
		digits_length += echo.mark_digits.length()
	
	if not Catalog.fusion_mark_lengths.has(digits_length):
		return false
	
	if digits_length == Catalog.MARK_DIGITS_MAX_LENGTH:
		return true
	
	for echo in echos_:
		if echo.mark_digits.length() != echos_.front().mark_digits.length():
			return false
	
	return Catalog.fusion_mark_lengths.has(digits_length)

func init_sources() -> void:
	for biome in Catalog.biomes:
		var source = load("res://entities/isle/biome/source/%s.tres" % Bozo.enum_to_string(Bozo.Type.BIOME, biome))
		source.update()
		biome_to_source[biome] = source
#endregion

func simulate_anvil_choice() -> void:
	var anvil = anvils.front()
	anvil.fusion()

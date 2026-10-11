class_name SlumberData
extends TaskData


signal turnpike_changed

var rift: RiftData
var reinforcement_echos: Array[EchoData]
var current_turnpike: int = 0:
	set(value_):
		current_turnpike = value_
		turnpike_changed.emit()


func _init(master_: MasterData, order_: int) -> void:
	rift = master_.guild.structure
	init_turnpike()
	super._init(master_, order_)

func init_turnpike() -> void:
	if not rift.gloom.is_elite: return
	var element = rift.gloom.element
	if Digest.element_to_addend.has(element):
		current_turnpike = Digest.element_to_addend[element]
		return
	var options = get_turnpike_choices()
	if options.is_empty(): return
	current_turnpike = options[0]
	if current_turnpike != 0:
		pass

func prepare_nightmare() -> void:
	Mother.nightmare.slumber = self
	update_attic()

func update_attic() -> void:
	var reinforcement_soul = agent.squad.members.back().virtual_soul
	reinforcement_echos.append_array(reinforcement_soul.echos)
	reinforcement_echos.shuffle()
	var echos: Array[EchoData]
	
	for member in agent.squad.members:
		if member.virtual_soul and member.virtual_soul != reinforcement_soul:
			echos.append_array(member.virtual_soul.echos)
	
	if echos.is_empty(): return
	echos.shuffle()
	Mother.house.attic.echos = echos

func get_reinforcements() -> Array[EchoData]:
	var echos: Array[EchoData]
	var n = min(reinforcement_echos.size(), Catalog.REINFORCEMENT_ECHOS_LIMIT)
	
	for _i in n:
		var echo = reinforcement_echos.pop_back()
		echos.append(echo)
	
	return echos

func changed_turnpike(shift_: int) -> void:
	var options = get_turnpike_choices()
	if options.is_empty(): return
	var index = options.find(current_turnpike)
	var n = options.size()
	index = (index + shift_ + n) % n
	current_turnpike = options[index]

func get_turnpike_choices() -> Array:
	var element = rift.gloom.element
	var comparison = Digest.element_to_comparison[element]
	var tune = Digest.element_to_tune[element]
	match comparison:
		Bozo.Comparison.EQUAL:
			return Helper.get_turnpike_options(tune)
		Bozo.Comparison.LESS, Bozo.Comparison.MORE:
			if Digest.element_to_addend.has(element):
				return [Digest.element_to_addend[element]]
			return []
	return []

func can_fill_squad() -> bool:
	if not rift.gloom.is_elite:
		return true
	if Mother.guild.souls.size() < Digest.master_to_squad_size[Bozo.Master.DEMON]:
		return false
	var comparison = Digest.element_to_comparison[rift.gloom.element]
	match comparison:
		Bozo.Comparison.EQUAL:
			return not get_turnpike_choices().is_empty()
		Bozo.Comparison.UNIQUE:
			return Helper.get_allowance_unique()
		Bozo.Comparison.LESS, Bozo.Comparison.MORE:
			if Catalog.turnpike_elements.has(rift.gloom.element) and current_turnpike == 0:
				return false
			return _has_limiter_squad_at(current_turnpike)
	return true

func get_member_options(member_: MemberData) -> Array:
	var options: Array = Mother.guild.souls
	if not rift.gloom.is_elite:
		return options
	if not can_fill_squad():
		return []
	var comparison = Digest.element_to_comparison[rift.gloom.element]
	
	match comparison:
		Bozo.Comparison.EQUAL:
			var tune = Digest.element_to_tune[rift.gloom.element]
			var dice_str = Bozo.enum_to_string(Bozo.Type.TUNE, tune)
			options = options.filter(func (a): return a.get(dice_str).get_sum() == current_turnpike)
		Bozo.Comparison.UNIQUE:
			var reserved_sums = member_.squad.get_reserved_sums(member_)
			options = options.filter(func (a): return a.is_unique(reserved_sums))
		Bozo.Comparison.LESS, Bozo.Comparison.MORE:
			options = options.filter(func (a): return _fits_limiter(member_, a))
	return options

# Сумма кубов отряда против LimitRein, тем же знаком, что на Limiter.
func _squad_sum_passes(souls_: Array) -> bool:
	var element = rift.gloom.element
	if not Digest.element_to_sum.has(element):
		return true
	var tune = Digest.element_to_tune[element]
	var dice_str = Bozo.enum_to_string(Bozo.Type.TUNE, tune)
	var sum_value := 0
	for soul in souls_:
		sum_value += soul.get(dice_str).get_sum()
	return _passes(sum_value, Digest.element_to_sum[element], Digest.element_to_comparison[element])

# Vapor/Sand: intro каждой души против current_turnpike.
func _soul_passes_turnpike(soul_: SoulData, turnpike_: int) -> bool:
	var element = rift.gloom.element
	if element != Bozo.Element.VAPOR and element != Bozo.Element.SAND:
		return true
	return _passes(soul_.intro.get_sum(), turnpike_, Digest.element_to_comparison[element])

func _passes(value_: int, limit_: int, comparison_: int) -> bool:
	match comparison_:
		Bozo.Comparison.LESS:
			return value_ < limit_
		Bozo.Comparison.MORE:
			return value_ > limit_
		Bozo.Comparison.EQUAL:
			return value_ == limit_
	return false

func _limiter_pool(excluding_: Array, turnpike_: int) -> Array:
	var pool: Array = []
	for soul in Mother.guild.souls:
		if excluding_.has(soul):
			continue
		if soul.task != null and soul.task != self:
			continue
		if not _soul_passes_turnpike(soul, turnpike_):
			continue
		pool.append(soul)
	return pool

func _has_limiter_squad_at(turnpike_: int) -> bool:
	var squad_size: int = Digest.master_to_squad_size[Bozo.Master.DEMON]
	return _can_complete([], _limiter_pool([], turnpike_), squad_size)

func _can_complete(chosen_: Array, pool_: Array, holes_: int) -> bool:
	if holes_ == 0:
		return _squad_sum_passes(chosen_)
	for i in pool_.size():
		var next: Array = chosen_.duplicate()
		next.append(pool_[i])
		if _can_complete(next, pool_.slice(i + 1), holes_ - 1):
			return true
	return false

# Уже выбранные соседи фиксируются. Пустые слоты добираются так, чтобы сумма прошла.
func _fits_limiter(member_: MemberData, soul_: SoulData) -> bool:
	if not _soul_passes_turnpike(soul_, current_turnpike):
		return false
	var fixed: Array = []
	for member in member_.squad.members:
		if member == member_ or member.preview_soul == null:
			continue
		if not _soul_passes_turnpike(member.preview_soul, current_turnpike):
			continue
		fixed.append(member.preview_soul)
	if fixed.has(soul_):
		return false
	var squad_size: int = Digest.master_to_squad_size[Bozo.Master.DEMON]
	var holes := squad_size - 1 - fixed.size()
	if holes < 0:
		return false
	var chosen: Array = fixed.duplicate()
	chosen.append(soul_)
	if holes == 0:
		return _squad_sum_passes(chosen)
	return _can_complete(chosen, _limiter_pool(chosen, current_turnpike), holes)

func test_update_attic() -> void:
	var reinforcement_soul = Mother.guild.souls.back()
	reinforcement_echos.append_array(reinforcement_soul.echos)
	reinforcement_echos.shuffle()
	var echos: Array[EchoData]
	
	for _i in 2:
		var soul = Mother.guild.souls[_i]
		echos.append_array(soul.echos)
	
	if echos.is_empty(): return
	echos.shuffle()
	Mother.house.attic.echos = echos

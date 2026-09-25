class_name BarkeeperData
extends MasterData


signal recruit_changed

var origins: Array[OriginData]

var alphabet: Array
var recruiment_matters: Array[Bozo.Matter]

var recruits: Array[RecruitData]

var current_recruit: RecruitData:
	set(value_):
		current_recruit = value_
		recruit_changed.emit()


func _init(guild_: GuildData) -> void:
	super._init(guild_)
	type = Bozo.Master.BARKEEPER
	refill_alphabet()
	init_recruits()

func init_recruits() -> void:
	recruits.clear()
	
	for _i in Catalog.BARKEEPER_RECRUIT_AMOUNT:
		add_recruit()
	
	current_recruit = recruits.front()

func add_recruit(intro_sum_: int = 40, talent_: int = 1, matter_: Variant = null) -> void:
	if matter_ == null:
		matter_ = Catalog.matters.pick_random()
	
	var intro = Digest.sum_to_matter_to_intro[intro_sum_][matter_].pick_random()
	var verse_index = Digest.matter_to_verse[matter_].pick_random()
	var verse = load("res://entities/dice/datas/verse/%d.tres" % verse_index)
	var origin = OriginData.new(self, matter_, intro, verse, talent_)
	var recriut = RecruitData.new(self, origin)
	recruits.append(recriut)

func changed_recruit(shift_: int) -> void:
	var index = recruits.find(current_recruit)
	var n = recruits.size()
	index = (index + shift_ + n) % n
	current_recruit = recruits[index]

	init_origins()

func init_origins() -> void:
	origins.clear()
	var n = 2
	
	for _i in n:
		recruiment_phase()

func refill_alphabet() -> void:
	if not alphabet.is_empty(): return
	var l = floori(float(origins.size()) / 26) + 1
	alphabet = range(26).map(func(a): return char(90 - a).repeat(l))
#endregion

#func discard_bedroom(is_phase_: bool = true) -> void:
	#var forge_stamps: Array[StampData]
	#forge_stamps.append_array(Mother.bedroom.stamps)
	#
	#Mother.arsenal.stamps.append_array(forge_stamps)
	#
	#Mother.house.bedroom.clear()
	#Mother.kernel.fleet.stamps.clear()
	#
	#if is_phase_:
		#Mother.house.atheneum.discard_phase.emit()
		#Mother.kernel.fleet.discard_phase.emit()

func recruiment_phase(intro_sum_: int = 20, matter_: Variant = null) -> void:
	if matter_ != null:
		recruiment_matters.append(matter_)
	
	if recruiment_matters.is_empty():
		recruiment_matters.append_array(Catalog.matters)
		recruiment_matters.shuffle()
	
	var matter = recruiment_matters.pop_back()
	var intro = Digest.sum_to_matter_to_intro[intro_sum_][matter].pick_random()
	var verse_index = Digest.matter_to_verse[matter].pick_random()
	var verse = load("res://entities/dice/datas/verse/%d.tres" % verse_index)
	var talent = 3
	var _origin = OriginData.new(self, matter, intro, verse, talent)
	Mother.house.attic.stamps.shuffle()

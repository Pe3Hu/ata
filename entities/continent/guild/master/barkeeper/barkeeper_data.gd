class_name BarkeeperData
extends MasterData



var origins: Array[OriginData]

var alphabet: Array
var recruiment_matters: Array[Bozo.Matter]


func _init(guild_: GuildData) -> void:
	super._init(guild_)
	type = Bozo.Master.BARKEEPER
	refill_alphabet()
	init_tasks()

func init_tasks() -> void:
	tasks.clear()
	
	for _i in Catalog.BARKEEPER_RECRUIT_AMOUNT:
		add_recruit()
	
	current_task = tasks.front()

func add_recruit(intro_sum_: int = 40, talent_: int = 1, matter_: Variant = null) -> void:
	if matter_ == null:
		matter_ = Catalog.matters.pick_random()
	
	var intro = Digest.sum_to_matter_to_intro[intro_sum_][matter_].pick_random()
	var verse_index = Digest.matter_to_verse[matter_].pick_random()
	var verse = load("res://entities/dice/datas/verse/%d.tres" % verse_index)
	var origin = OriginData.new(self, matter_, intro, verse, talent_)
	var recriut = RecruitData.new(self, origin)
	tasks.append(recriut)

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

class_name BarkeeperData
extends MasterData


signal recruit_changed

var recruits: Array[RecruitData]

var current_recruit: RecruitData:
	set(value_):
		current_recruit = value_
		recruit_changed.emit()


func _init(guild_: GuildData) -> void:
	super._init(guild_)
	init_recruits()

func init_recruits() -> void:
	recruits.clear()
	
	for _i in Catalog.BARKEEPER_RECRUIT_AMOUNT:
		add_recruit()
	
	current_recruit = recruits.front()

func add_recruit(intro_sum_: int = 20, matter_: Variant = null) -> void:
	if matter_ == null:
		matter_ = Catalog.matters.pick_random()
	
	var intro = Digest.sum_to_matter_to_intro[intro_sum_][matter_].pick_random()
	var verse_index = Digest.matter_to_verse[matter_].pick_random()
	var verse = load("res://entities/dice/datas/verse/%d.tres" % verse_index)
	var origin = OriginData.new(matter_, intro, verse)
	var recriut = RecruitData.new(origin)
	recruits.append(recriut)

func changed_recruit(shift_: int) -> void:
	var index = recruits.find(current_recruit)
	var n = recruits.size()
	index = (index + shift_ + n) % n
	current_recruit = recruits[index]

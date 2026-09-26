class_name MusicianData
extends MasterData



func _init(guild_: GuildData) -> void:
	super._init(guild_)
	type = Bozo.Master.BARKEEPER
	init_tasks()

func init_tasks() -> void:
	tasks.clear()
	
	for _i in Catalog.BARKEEPER_RECRUIT_AMOUNT:
		add_veteran()
	
	current_task = tasks.front()

func add_veteran(intro_sum_: int = 40, talent_: int = 1, matter_: Variant = null) -> void:
	if matter_ == null:
		matter_ = Catalog.matters.pick_random()
	
	var intro = Digest.sum_to_matter_to_intro[intro_sum_][matter_].pick_random()
	var verse_index = Digest.matter_to_verse[matter_].pick_random()
	var verse = load("res://entities/dice/datas/verse/%d.tres" % verse_index)
	var origin = OriginData.new(self, matter_, intro, verse, talent_)
	var recriut = VeteranData.new(self, origin)
	tasks.append(recriut)

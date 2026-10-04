class_name BarkeeperData
extends MasterData


var souls: Array[SoulData]

var recruiment_matters: Array[Bozo.Matter]

var month: int = 0
var name_letter: String = ''


func _init(guild_: GuildData, type_: Bozo.Master) -> void:
	super._init(guild_, type_)

func init_static_tasks() -> void:
	tasks.clear()
	var intros = Digest.month_to_recruit_intros[month]
	var talents = Digest.month_to_recruit_talents[month]
	var matters = Catalog.matters.duplicate()
	matters.shuffle()
	var names = guild.get_names()
	
	for _i in talents.size():
		add_recruit(intros[_i], talents[_i], matters[_i], names[_i])
	
	current_task = tasks.front()
	print_debug('remove letter after recruit')

func add_recruit(intro_sum_: int = 40, talent_: int = 0, matter_: Variant = null, name_: String = '') -> void:
	if matter_ == null:
		matter_ = Catalog.matters.pick_random()
	
	var intro = Digest.sum_to_matter_to_intro[intro_sum_][matter_].pick_random()
	var verse = load("res://entities/dice/datas/verse/0.tres")
	var soul = SoulData.new(self, matter_, intro, verse, talent_, name_)
	RecruitData.new(self, 0, soul)
#endregion

func recruiment_phase(soul_: SoulData = null) -> void:
	if soul_ != null:
		if not souls.has(soul_): 
			souls.append(soul_)
		return

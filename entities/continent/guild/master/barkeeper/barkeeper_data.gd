class_name BarkeeperData
extends MasterData


var origins: Array[OriginData]

var alphabet: Array
var recruiment_matters: Array[Bozo.Matter]

var month: int = 0
var name_letter: String = ''


func _init(guild_: GuildData, type_: Bozo.Master) -> void:
	refill_alphabet()
	init_default_origins()
	super._init(guild_, type_)

func init_static_tasks() -> void:
	tasks.clear()
	var intros = Digest.month_to_recruit_intros[month]
	var talents = Digest.month_to_recruit_talents[month]
	var matters = Catalog.matters.duplicate()
	matters.shuffle()
	var names = get_names()
	
	for _i in talents.size():
		add_recruit(intros[_i], talents[_i], matters[_i], names[_i])
	
	current_task = tasks.front()
	print_debug('remove letter after recruit')

func add_recruit(intro_sum_: int = 40, talent_: int = 0, matter_: Variant = null, name_: String = '') -> void:
	if matter_ == null:
		matter_ = Catalog.matters.pick_random()
	
	var intro = Digest.sum_to_matter_to_intro[intro_sum_][matter_].pick_random()
	var verse = load("res://entities/dice/datas/verse/0.tres")
	var origin = OriginData.new(self, matter_, intro, verse, talent_, name_)
	RecruitData.new(self, 0, origin)

func init_default_origins() -> void:
	origins.clear()
	var n = 3
	
	for _i in n:
		recruiment_phase()
	
	Mother.house.attic.stamps.shuffle()

func refill_alphabet() -> void:
	if not alphabet.is_empty(): return
	var l = floori(float(origins.size()) / 26) + 1
	alphabet = range(26).map(func(a): return char(90 - a).repeat(l))
	alphabet = alphabet.filter(func (a): return not Catalog.vowels.has(a))
	alphabet.shuffle()
#endregion

func recruiment_phase() -> void:
	if recruiment_matters.is_empty():
		recruiment_matters.append_array(Catalog.matters)
		recruiment_matters.shuffle()
	
	var matter = recruiment_matters.pop_back()
	var intro_sum = Catalog.DEFAULT_RECRUIT_INTRO
	var intro = Digest.sum_to_matter_to_intro[intro_sum][matter].pick_random()
	var verse_index = Digest.matter_to_verse[matter].pick_random()
	var verse = load("res://entities/dice/datas/verse/%d.tres" % verse_index)
	var talent = Catalog.DEFAULT_RECRUIT_TALENT
	var origin = OriginData.new(self, matter, intro, verse, talent)
	origins.append(origin)

func roll_name() -> String:
	if name_letter == '':
		name_letter = alphabet.pop_back()
	
	var options = Helper.get_random_names(name_letter)
	var pantheons = options.keys()
	var pantheon = pantheons.pick_random()
	return options[pantheon]

func get_names() -> Array[String]:
	name_letter = alphabet.pick_random()
	var options = Helper.get_random_names(name_letter)
	var names := []
	
	for pantheon in options:
		var name = options[pantheon]
		names.append(name)
	
	return names

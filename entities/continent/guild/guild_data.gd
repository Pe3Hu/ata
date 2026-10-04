class_name GuildData
extends RefCounted


signal master_changed

var structure: StructureData:
	set(value_):
		if structure != value_: 
			structure = value_
			
			if structure and structure.type != Bozo.Master.NONE:
				set_current_master(Digest.structure_to_master[structure.type])

var demon: DemonData
var barkeeper: BarkeeperData
var architect: ArchitectData
var blacksmith: BlacksmithData
var archaeologist: ArchaeologistData
var lightkeeper: LightkeeperData
var miner: MinerData
var musician: MusicianData
var scout: ScoutData
var tailor: TailorData

var current_master: MasterData
var hourglass_time: float = 0.0

var souls: Array[SoulData]
var alphabet: Array

func _init() -> void:
	demon = DemonData.new(self, Bozo.Master.DEMON)
	init_default_souls()
	barkeeper = BarkeeperData.new(self, Bozo.Master.BARKEEPER)
	architect = ArchitectData.new(self, Bozo.Master.ARCHITECT)
	blacksmith = BlacksmithData.new(self, Bozo.Master.BLACKSMITH)
	archaeologist = ArchaeologistData.new(self, Bozo.Master.ARCHAEOLOGIST)
	lightkeeper = LightkeeperData.new(self, Bozo.Master.LIGHTKEEPER)
	miner = MinerData.new(self, Bozo.Master.MINER)
	musician = MusicianData.new(self, Bozo.Master.MUSICIAN)
	scout = ScoutData.new(self, Bozo.Master.SCOUT)
	tailor = TailorData.new(self, Bozo.Master.TAILOR)

func init_default_souls() -> void:
	refill_alphabet()
	souls.clear()
	var n = 3
	var recruiment_matters = []
	
	for _i in n:
		var soul = make_random_soul(recruiment_matters)
		souls.append(soul)
	
	Mother.house.attic.echos.shuffle()

func make_random_soul(recruiment_matters_: Array) -> SoulData:
	if recruiment_matters_.is_empty():
		recruiment_matters_.append_array(Catalog.matters)
		recruiment_matters_.shuffle()
	var matter = recruiment_matters_.pop_back()
	var intro = Digest.sum_to_matter_to_intro[Catalog.DEFAULT_RECRUIT_INTRO][matter].pick_random()
	var verse = load("res://entities/dice/datas/verse/%d.tres" % Digest.matter_to_verse[matter].pick_random())
	return SoulData.new(demon, matter, intro, verse, Catalog.DEFAULT_RECRUIT_TALENT)

func set_current_master(type_: Bozo.Master):
	if type_ == Bozo.Master.NONE:
		current_master = null
		return
	
	var str_type = Bozo.enum_to_string(Bozo.Type.MASTER, type_)
	var master = get(str_type)
	
	if current_master:
		match current_master.type:
			Bozo.Master.SCOUT:
				if current_master.current_task.agent.get_virtual() == null:
					Mother.mainland.beam.reset()
			Bozo.Master.MINER:
				current_master.tasks.clear()
	
	if master:
		current_master = master
		current_master.type = type_
		current_master.init_dinamic_tasks()
		master_changed.emit()

func refill_alphabet() -> void:
	if not alphabet.is_empty(): return
	#var l = floori(float(guild.souls.size()) / 26) + 1
	#alphabet = range(26).map(func(a): return char(90 - a).repeat(l))
	alphabet = range(26).map(func(a): return char(90 - a))
	alphabet = alphabet.filter(func (a): return not Catalog.vowels.has(a))
	alphabet.shuffle()

func roll_name() -> String:
	if Mother.guild and barkeeper:
		if barkeeper.name_letter == '':
			barkeeper.name_letter = alphabet.pop_back()
		
		var options = Helper.get_random_names(barkeeper.name_letter)
		var pantheons = options.keys()
		var pantheon = pantheons.pick_random()
		barkeeper.name_letter = ''
		return options[pantheon]
	
	var mames = get_names()
	return mames.pick_random()

func get_names() -> Array[String]:
	var letter = alphabet.pick_random()
	var options = Helper.get_random_names(letter)
	var names := []
	
	for pantheon in options:
		var _name = options[pantheon]
		names.append(_name)
	
	return names

func test_veins() -> void:
	for matter in Digest.matter_to_rank_to_volume_to_percent:
		for rank in Digest.matter_to_rank_to_volume_to_percent[matter]:
			var sum = 0
			var sum1 = 0
			
			for volume in Digest.matter_to_rank_to_volume_to_percent[matter][rank]:
				sum += Digest.matter_to_rank_to_volume_to_percent[matter][rank][volume] * volume
				sum1 += Digest.matter_to_rank_to_volume_to_percent[matter][rank][volume]
			print([matter, rank, sum1, sum])

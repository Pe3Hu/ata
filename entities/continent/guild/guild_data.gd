class_name GuildData
extends RefCounted


signal master_changed

var structure: StructureData:
	set(value_):
		if structure != value_: 
			structure = value_
			
			if structure and structure.type != Bozo.Master.NONE:
				set_current_master(Digest.structure_to_master[structure.type])

var architect = ArchitectData.new(self)
var barkeeper = BarkeeperData.new(self)
var blacksmith = BlacksmithData.new(self)
#var demon = DemonData.new(self)
var guardian = GuardianData.new(self)
var lightkeeper = LightkeeperData.new(self)
var miner = MinerData.new(self)
var musician = MusicianData.new(self)
var scout = ScoutData.new(self)
var tailor = TailorData.new(self)

var current_master: MasterData


func set_current_master(type_: Bozo.Master):
	if type_ == Bozo.Master.NONE:
		current_master = null
		return
	
	var str_type = Bozo.enum_to_string(Bozo.Type.MASTER, type_)
	var master = get(str_type)
	
	if master:
		current_master = master
		current_master.type = type_
		
		match type_:
			Bozo.Master.BLACKSMITH:
				current_master.init_instruments()
			Bozo.Master.MINER:
				current_master.init_caves()
			Bozo.Master.TAILOR:
				current_master.init_attires()
			Bozo.Master.SCOUT:
				current_master.init_spotlights()
		
		master_changed.emit()


func test_veins() -> void:
	for matter in Digest.matter_to_rank_to_volume_to_percent:
		for rank in Digest.matter_to_rank_to_volume_to_percent[matter]:
			var sum = 0
			var sum1 = 0
			
			for volume in Digest.matter_to_rank_to_volume_to_percent[matter][rank]:
				sum += Digest.matter_to_rank_to_volume_to_percent[matter][rank][volume] * volume
				sum1 += Digest.matter_to_rank_to_volume_to_percent[matter][rank][volume]
			print([matter, rank, sum1, sum])

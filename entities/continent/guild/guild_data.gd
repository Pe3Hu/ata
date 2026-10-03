class_name GuildData
extends RefCounted


signal master_changed

var structure: StructureData:
	set(value_):
		if structure != value_: 
			structure = value_
			
			if structure and structure.type != Bozo.Master.NONE:
				set_current_master(Digest.structure_to_master[structure.type])

var architect = ArchitectData.new(self, Bozo.Master.ARCHITECT)
var barkeeper = BarkeeperData.new(self, Bozo.Master.BARKEEPER)
var blacksmith = BlacksmithData.new(self, Bozo.Master.BLACKSMITH)
#var demon = DemonData.new(self, Bozo.Master.)
var guardian = GuardianData.new(self, Bozo.Master.GUARDIAN)
var lightkeeper = LightkeeperData.new(self, Bozo.Master.LIGHTKEEPER)
var miner = MinerData.new(self, Bozo.Master.MINER)
var musician = MusicianData.new(self, Bozo.Master.MUSICIAN)
var scout = ScoutData.new(self, Bozo.Master.SCOUT)
var tailor = TailorData.new(self, Bozo.Master.TAILOR)

var current_master: MasterData
var hourglass_time: float = 0.0


func set_current_master(type_: Bozo.Master):
	if type_ == Bozo.Master.NONE:
		current_master = null
		return
	
	var str_type = Bozo.enum_to_string(Bozo.Type.MASTER, type_)
	var master = get(str_type)
	
	if current_master:
		match current_master.type:
			Bozo.Master.SCOUT:
				if current_master.current_task.agent.soul == null:
					Mother.mainland.beam.reset()
			Bozo.Master.MINER:
				current_master.tasks.clear()
	
	if master:
		current_master = master
		current_master.type = type_
		current_master.init_dinamic_tasks()
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

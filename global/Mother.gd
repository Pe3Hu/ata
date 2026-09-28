extends Node


signal declare_gameover
signal clock_updated(hand_angle: float)

var kernel: KernelData
var house: HouseData
var odeum: OdeumData

var arsenal: ArsenalData
var mission: MissionData
var welkin: WelkinData

var mainland: MainlandData
var guild: GuildData
var clock: ClockData


func _ready() -> void:
	welkin = WelkinData.new()
	odeum = OdeumData.new()
	house = HouseData.new()
	
	mainland = MainlandData.new()
	guild = GuildData.new()
	
	arsenal = ArsenalData.new()
	mission = MissionData.new()
	
	kernel = KernelData.new()
	clock = ClockData.new()
	
	declare_gameover.connect(_on_declare_gameover)
	clock.time_changed.connect(func(_t): clock_updated.emit(clock.get_hand_angle()))

func _on_declare_gameover() -> void:
	Arbitrator.s_gameover = true

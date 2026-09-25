extends Node


signal declare_gameover

var kernel: KernelData
var house: HouseData
var odeum: OdeumData

var arsenal: ArsenalData
var mission: MissionData
var welkin: WelkinData

var mainland: MainlandData
var guild: GuildData


func _ready() -> void:
	welkin = WelkinData.new()
	odeum = OdeumData.new()
	house = HouseData.new()
	
	mainland = MainlandData.new()
	guild = GuildData.new()
	
	arsenal = ArsenalData.new()
	mission = MissionData.new()
	
	kernel = KernelData.new()
	
	declare_gameover.connect(_on_declare_gameover)

func _on_declare_gameover() -> void:
	Arbitrator.s_gameover = true

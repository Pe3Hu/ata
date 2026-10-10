extends Node


signal declare_gameover
signal clock_updated(hand_angle: float)

static var nightmare: NightmareData
static var house: HouseData

static var kernel: KernelData
static var odeum: OdeumData

static var arsenal: ArsenalData
static var welkin: WelkinData

static var mainland: MainlandData
static var guild: GuildData
static var clock: ClockData
static var overseer: OverseerData

static var cottage: CottageData
static var depredation: DepredationData


func _ready() -> void:
	welkin = WelkinData.new()
	odeum = OdeumData.new()
	house = HouseData.new()
	nightmare = NightmareData.new()
	
	mainland = MainlandData.new()
	guild = GuildData.new()
	
	arsenal = ArsenalData.new()
	
	kernel = KernelData.new()
	clock = ClockData.new()
	overseer = OverseerData.new()
	
	cottage = CottageData.new()
	depredation = DepredationData.new()
	
	declare_gameover.connect(_on_declare_gameover)
	clock.time_changed.connect(func(_t): clock_updated.emit(clock.get_hand_angle()))

func _on_declare_gameover() -> void:
	Arbitrator.s_gameover = true

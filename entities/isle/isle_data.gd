class_name IsleData
extends RefCounted


var kernel: KernelData
var atheneum: AtheneumData
var odeum: OdeumData

var policy: PolicyData
var arsenal: ArsenalData
var mission: MissionData
var welkin: WelkinData


func _init() -> void:
	arsenal = ArsenalData.new()
	policy = PolicyData.new(self)
	
	atheneum = policy.player_faction.atheneum
	kernel = policy.player_faction.kernel
	odeum = policy.player_faction.odeum
	
	#mission = MissionData.new(self)
	welkin = WelkinData.new(self)

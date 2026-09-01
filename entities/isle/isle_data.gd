class_name IsleData
extends RefCounted


var kernel: KernelData
var atheneum: AtheneumData
var odeum: OdeumData

var policy: PolicyData
var forge: ForgeData
var mission: MissionData


func _init() -> void:
	forge = ForgeData.new()
	policy = PolicyData.new(self)
	
	atheneum = policy.player_faction.atheneum
	kernel = policy.player_faction.kernel
	odeum = policy.player_faction.odeum
	
	mission = MissionData.new(self)

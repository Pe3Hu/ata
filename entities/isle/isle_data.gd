class_name IsleData
extends RefCounted


var kernel: KernelData
var atheneum: AtheneumData
var odeum: OdeumData

var policy: PolicyData
var forge: ForgeData


func _init() -> void:
	forge = ForgeData.new()
	policy = PolicyData.new(self)
	
	for faction in policy.factions:
		if faction.is_active:
			faction.kernel.apply_starter_volumes()
	
	atheneum = policy.current_faction.atheneum
	kernel = policy.current_faction.kernel
	odeum = policy.current_faction.odeum

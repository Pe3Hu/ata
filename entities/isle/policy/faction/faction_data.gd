class_name FactionData
extends RefCounted


var policy: PolicyData
var is_active: bool
var index: int

var kernel: KernelData
var atheneum: AtheneumData
var odeum: OdeumData

var settlements: Array[SettlementData]


#region init
func _init(policy_: PolicyData, is_active_: bool = false) -> void:
	policy = policy_
	is_active = is_active_
	
	index = policy_.factions.size()
	policy_.factions.append(self)
	
	if is_active:
		odeum = OdeumData.new(self)
		kernel = KernelData.new(self)
		
		atheneum = AtheneumData.new(self)
#endregion

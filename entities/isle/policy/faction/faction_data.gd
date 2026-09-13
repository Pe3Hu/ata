class_name FactionData
extends RefCounted


signal declare_gameover

var policy: PolicyData
var is_active: bool
var index: int

var kernel: KernelData
var atheneum: AtheneumData
var odeum: OdeumData



#region init
func _init(policy_: PolicyData, is_active_: bool = false) -> void:
	policy = policy_
	is_active = is_active_
	
	index = policy_.factions.size()
	
	declare_gameover.connect(_on_declare_gameover)
	policy_.factions.append(self)
	
	if is_active:
		odeum = OdeumData.new(self)
		kernel = KernelData.new(self)
		
		atheneum = AtheneumData.new(self)
#endregion

func _on_declare_gameover() -> void:
	Arbitrator.s_gameover = true

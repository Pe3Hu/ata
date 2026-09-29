class_name TaskData
extends RefCounted


signal is_finished

var master: MasterData
var agent: AgentData = null
var tribute: TributeData

var rank: int


func _init(master_: MasterData, rank_: int) -> void:
	master = master_
	rank = rank_
	
	agent = AgentData.new(self)
	master.tasks.append(self)
	
	init_tribute()
	is_finished.connect(_on_finished)

func init_tribute() -> void:
	var price = Digest.master_to_price[master.type] * (rank + 1)
	var volumes = Digest.master_to_volumes[master.type]
	tribute = TributeData.new(price, volumes)

func _on_finished() -> void:
	agent.unassign()
	master.tasks.clear()
	master.init_static_tasks()
	
	if master.tasks.is_empty():
		master.init_dinamic_tasks()

class_name TaskData
extends RefCounted


signal is_finished

var master: MasterData
var agent: AgentData = null
var tributes: Array[TributeData]

var order: int


func _init(master_: MasterData, order_: int) -> void:
	master = master_
	order = order_
	
	agent = AgentData.new(self)
	master.tasks.append(self)
	
	init_tributes()
	is_finished.connect(_on_finished)

func init_tributes() -> void:
	var price = Digest.master_to_price[master.type] * (order + 1)
	var volumes = Digest.master_to_volumes[master.type]
	tributes = [TributeData.new(price, volumes)]

func _on_finished() -> void:
	if agent != null:
		agent.unassign(true)
	master.tasks.clear()
	master.init_static_tasks()
	
	if master.tasks.is_empty():
		master.init_dinamic_tasks()

func pay() -> void:
	for _tribe in tributes:
		_tribe.introduce_quotums()

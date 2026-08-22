class_name Kernel
extends PanelContainer


@export var volume_scene = preload("uid://dpvkcodr3cjop")

var data: KernelData:
	set(value_):
		data = value_
		connect_datas()
		connect_signals()

@export var usurer: Usurer
@export var pie: Pie


#region init
func connect_datas() -> void:
	usurer.data = data.usurer
	pie.data = data.pie

func connect_signals() -> void:
	data.growth_phase.connect(_on_growth_phase)
	data.stock_phase.connect(_on_stock_phase)

func _on_growth_phase() -> void:
	pass
	#harvest.update_straw_amounts()

func _on_stock_phase() -> void:
	pass
	#granary.update_straw_amounts()
	#harvest.update_straw_amounts()
	#zoo.reset()
#endregion

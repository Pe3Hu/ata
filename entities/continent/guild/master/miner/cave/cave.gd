class_name Cave
extends Task


func connect_signals() -> void:
	super.connect_signals()
	%Lode.data = data.lode

func _on_task_changed() -> void:
	super._on_task_changed()
	%Lode.data = data.lode

func update_order_textures() -> void:
	super.update_order_textures()
	%AvgValue.text = str(Digest.order_to_avg[data.order])
	var amount = Digest.master_to_price[data.master.type] * (data.order + 1) * Catalog.MINER_SPOIL_FACTOR
	%AmountValue.text = str(amount)

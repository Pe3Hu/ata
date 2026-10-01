class_name Cave
extends Task


func connect_signals() -> void:
	super.connect_signals()
	%Lode.data = data.lode

func _on_task_changed() -> void:
	super._on_task_changed()
	%Lode.data = data.lode

func update_rank_textures() -> void:
	super.update_rank_textures()
	%AvgValue.text = str(Digest.rank_to_avg[data.rank])
	var amount = Digest.master_to_price[data.master.type] * (data.rank + 1) * Catalog.MINER_SPOIL_FACTOR
	%AmountValue.text = str(amount)

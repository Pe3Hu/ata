class_name Cave
extends Task


func connect_signals() -> void:
	%Lode.data = data.lode
	super.connect_signals()

func _on_task_changed() -> void:
	super._on_task_changed()
	%Lode.data = data.lode

func update_rank_textures() -> void:
	super.update_rank_textures()
	%AvgValue.text = str(Digest.rank_to_avg[data.rank])

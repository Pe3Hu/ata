class_name ArchitectData
extends MasterData


var altars: Array[AltarData]


func init_dinamic_tasks() -> void:
	tasks.clear()
	SculptureData.new(self, 0)
	current_task = tasks.front()

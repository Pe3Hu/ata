class_name ArchitectData
extends MasterData



func init_static_tasks() -> void:
	tasks.clear()
	
	for asterism in Mother.welkin.asterisms:
		SculptureData.new(self, 0, asterism)
	
	current_task = tasks.front()

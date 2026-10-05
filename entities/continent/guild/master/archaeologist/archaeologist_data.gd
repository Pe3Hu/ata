class_name ArchaeologistData
extends MasterData


func init_tasks() -> void:
	tasks.clear()
	ExcavationData.new(self, guild.structure.order)

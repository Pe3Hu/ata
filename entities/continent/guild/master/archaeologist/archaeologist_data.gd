class_name ArchaeologistData
extends MasterData


func init_tasks() -> void:
	ExcavationData.new(self, guild.structure.order)

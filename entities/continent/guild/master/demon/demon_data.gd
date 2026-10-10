class_name DemonData
extends MasterData


func init_tasks() -> void:
	SlumberData.new(self, guild.structure.order)

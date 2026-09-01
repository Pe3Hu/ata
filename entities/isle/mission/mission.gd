class_name Mission
extends PanelContainer


var data: MissionData:
	set(value_):
		data = value_
		
		init_ideas()



func init_ideas() -> void:
	for idea in Catalog.ideas:
		var a 

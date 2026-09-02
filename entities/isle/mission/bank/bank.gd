class_name Bank
extends PanelContainer


var idea_scene = preload('uid://bug16p4odki30')

var data: BankData:
	set(value_):
		data = value_
		
		#init_ideas()


func init_ideas() -> void:
	for idea_data in data.gang.ideas:
		add_idea(idea_data)

func add_idea(idea_data_: IdeaData) -> void:
	var idea = idea_scene.instantiate()
	%Ideas.add_child(idea)
	idea.data = idea_data_

class_name Idea
extends Control


var intention_scene = preload('uid://bhtnr3epno3wi')

var data: IdeaData:
	set(value_):
		data = value_
		
		init_intentions()



func init_intentions() -> void:
	for intention_data in data.intentions:
		add_intention(intention_data)

func add_intention(intention_data: IntentionData) -> void:
	var intention = intention_scene.instantiate()
	%Intentions.add_child(intention)
	intention.data = intention_data

class_name Gang
extends PanelContainer


var idea_scene = preload('uid://bug16p4odki30')

var data: GangData:
	set(value_):
		data = value_
		
		connect_signals()
		init_ideas()

var data_to_idea: Dictionary


func connect_signals() -> void:
	data.idea_chaged.connect(_on_idea_changed)

func _on_idea_changed() -> void:
	pass
	#if data.first_idea:
		#var first_idea = data_to_idea[data.first_idea]
		#first_idea.apply_active()
	#
	#if data.second_idea:
		#var second_idea = data_to_idea[data.second_idea]
		#second_idea.apply_active()

func init_ideas() -> void:
	%Ideas.offset_transform_position = -Catalog.IDEA_SIZE / 2
	
	for idea_data in data.ideas:
		add_idea(idea_data)

func add_idea(idea_data_: IdeaData) -> void:
	var idea = idea_scene.instantiate()
	%Ideas.add_child(idea)
	idea.data = idea_data_
	data_to_idea[idea_data_] = idea

class_name Gang
extends PanelContainer


var idea_scene = preload('uid://bug16p4odki30')

var data: GangData:
	set(value_):
		data = value_
		
		connect_signals()
		connect_datas()
		init_ideas()

@export var ambition: Ambition

var data_to_idea: Dictionary


#region init
func connect_signals() -> void:
	data.attempt.idea_chaged.connect(_on_idea_changed)

func connect_datas() -> void:
	ambition.data = data.ambition

func _on_idea_changed() -> void:
	if data.attempt.first_idea and data.attempt.second_idea:
		var intention_data = Helper.find_intersection(data.attempt.first_idea, data.attempt.second_idea).front()
		data.attempt.first_idea.bond_aspect = intention_data.aspect
		data.attempt.first_idea.bond_element = intention_data.element
		data.attempt.second_idea.bond_aspect = intention_data.aspect
		data.attempt.second_idea.bond_element = intention_data.element
		data.ambition.recalc_potentials()
		data.attempt.recalc_impulses()

func init_ideas() -> void:
	%Ideas.offset_transform_position = -Catalog.IDEA_SIZE / 2
	
	for idea_data in data.ideas:
		add_idea(idea_data)

func add_idea(idea_data_: IdeaData) -> void:
	var idea = idea_scene.instantiate()
	%Ideas.add_child(idea)
	idea.data = idea_data_
	data_to_idea[idea_data_] = idea
#endregion

class_name Odeum
extends PanelContainer


@export var hymn_scene = preload("uid://bb3i0hbvmp0f7")

var data: OdeumData:
	set(value_):
		data = value_
		
		connect_signals()


#region init
func connect_signals() -> void:
	data.bedroom_scenario_changed.connect(_on_bedroom_scenario_changed)
	data.kitchen_scenario_changed.connect(_on_kitchen_scenario_changed)

func _on_bedroom_scenario_changed() -> void:
	var box = %BedroomHymns
	Helper.clear_children(box)
	
	if data.bedroom_scenario:
		for hymn_data in data.bedroom_scenario.hymns:
			add_hymn(hymn_data, box)

func _on_kitchen_scenario_changed() -> void:
	var box = %KitchenHymns
	Helper.clear_children(box)
	
	if data.kitchen_scenario:
		for hymn_data in data.kitchen_scenario.hymns:
			add_hymn(hymn_data, box)

func add_hymn(hymn_data_: HymnData, hbox_: BoxContainer) -> void:
	var hymn = hymn_scene.instantiate()
	hbox_.add_child(hymn)
	hymn.data = hymn_data_
	hymn.odeum = self
#endregion

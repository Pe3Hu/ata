class_name Silhouette
extends PanelContainer


@export var stake_scene = preload("uid://ddqqetmqeecl1")

var data: SilhouetteData:
	set(value_):
		data = value_
		
		init_stakes()
		update_colors()


func init_stakes() -> void:
	for type in Catalog.stakes:
		var stake_datas = data.stamp.type_to_stakes[type]
		
		match type:
			Bozo.Stake.LEFT:
				stake_datas.sort_custom(func (a, b): return a.joints.front() < b.joints.front())
			Bozo.Stake.LEFT:
				stake_datas.sort_custom(func (a, b): return a.value < b.value)
		
		for stake_data in stake_datas:
			add_stake(stake_data)

func add_stake(stake_data_: StakeData) -> void:
	var stake = stake_scene.instantiate()
	var stakes = get_stakes(stake_data_.type)
	stakes.add_child(stake)
	stake.data = stake_data_

func get_stakes(type_: Bozo.Stake) -> VBoxContainer:
	var path = Bozo.enum_to_string(Bozo.Type.STAKE, type_)
	path = "%" + path.capitalize() + "Stakes"
	return get_node(path)

func update_colors() -> void:
	var color = Digest.matter_to_color[data.origin.matter]
	%Border.get_theme_stylebox("panel").border_color = color

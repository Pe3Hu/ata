class_name Ambition
extends PanelContainer


var potential_scene = preload('uid://cdggi3dd7fivl')

var data: AmbitionData:
	set(value_):
		data = value_
		
		connect_signals()
		init_potentials()


#region init
func _ready() -> void:
	%Potentials.offset_transform_position = -Catalog.AMBITION_CENTER * Catalog.POTENTIAL_SIZE
	%Potentials.offset_transform_position.x += Catalog.POTENTIAL_OFFSET * 0.75
	%Potentials.offset_transform_position.y += Catalog.POTENTIAL_OFFSET

func connect_signals() -> void:
	#data.active_changed.connect(_on_active_changed)
	pass

func init_potentials() -> void:
	for potential_data in data.potentials:
		add_potential(potential_data)

func add_potential(potential_data: PotentialData) -> void:
	var potential = potential_scene.instantiate()
	%Potentials.add_child(potential)
	#potential.idea = self
	potential.data = potential_data
#endregion

class_name Guild
extends PanelContainer


var data: MasterData

@export var current: Master


func _ready() -> void:
	data = Mother.mainland.master
	data.type_changed.connect(_on_type_changed)
	_on_type_changed()

func _on_type_changed() -> void:
	if is_instance_valid(current):
		remove_child(current)
		current.queue_free()
		current = null

	if data.type == Bozo.Master.NONE:
		return

	var str_type := Bozo.enum_to_string(Bozo.Type.MASTER, data.type)
	var path := "res://entities/continent/guild/master/%s/%s.tscn" % [str_type, str_type]
	if not ResourceLoader.exists(path):
		push_error("Master scene not found: " + path)
		return

	var scene: PackedScene = load(path)
	current = scene.instantiate()
	add_child(current)

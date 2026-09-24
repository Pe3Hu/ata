class_name Guild
extends PanelContainer


@export var mainland: Mainland
@export var current: Master


func _ready() -> void:
	Mother.guild.master_changed.connect(_on_master_changed)
	_on_master_changed()

func _on_master_changed() -> void:
	if is_instance_valid(current):
		remove_child(current)
		current.queue_free()
		current = null

	if not Mother.guild.current_master:
		return

	var str_type = Bozo.enum_to_string(Bozo.Type.MASTER, Mother.guild.current_master.type)
	var path = "res://entities/continent/guild/master/%s/%s.tscn" % [str_type, str_type]
	if not ResourceLoader.exists(path):
		push_error("Master scene not found: " + path)
		return

	var scene: PackedScene = load(path)
	current = scene.instantiate()
	add_child(current)

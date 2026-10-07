class_name Banner
extends AnimatedSprite2D


var data: BannerData:
	set(value_):
		data = value_
		connect_signals()


func _ready() -> void:
	data = Mother.mainland.banner
	play('idle')

func connect_signals() -> void:
	data.structure_changed.connect(_on_structure_changed)
	_on_structure_changed()

func _on_structure_changed() -> void:
	visible = data.structure != null
	
	if data.structure != null:
		var cluster_position = Helper.get_cluster_position(data.structure.cluster)
		var structure_position = Helper.get_structure_position(data.structure)
		var offset_shift = Catalog.BANNER_OFFSET
		position = cluster_position + structure_position + offset_shift

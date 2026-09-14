extends Label

@export var fog: Node2D

func _ready() -> void:
	fog.territory_changed.connect(_on_changed)
	_on_changed(fog.territory_percent)

func _on_changed(percent: float) -> void:
	text = "Туман: %d%%" % roundi(percent)

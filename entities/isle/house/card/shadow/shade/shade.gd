class_name Shade
extends PanelContainer


var data: ShadeData:
	set(value_):
		data = value_
		
		connect_signals()
		#Helper.update_matter_colors(%Body, [data.shadow.echo.soul.matter])


func connect_signals() -> void:
	data.value_changed.connect(_on_value_changed)
	_on_value_changed()

func _on_value_changed() -> void:
	%Value.texture = load("res://entities/dice/images/%d.png" % data.current_value)

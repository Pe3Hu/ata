class_name Instrument
extends Task


func connect_signals() -> void:
	super.connect_signals()
	%Showcase.update_razors(data.razors)

	if not data.agent.squad.members[0].preview_soul_changed.is_connected(_on_preview_soul_changed):
		data.agent.squad.members[0].preview_soul_changed.connect(_on_preview_soul_changed)
	
	_on_preview_soul_changed()

func _on_preview_soul_changed() -> void:
	%Chart.data = data.agent.squad.members[0].preview_soul.chart

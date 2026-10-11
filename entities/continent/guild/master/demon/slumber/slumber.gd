class_name Slumber
extends Task


func connect_signals() -> void:
	super.connect_signals()
	%Gloom.data = data.rift.gloom
	
	for member in data.agent.squad.members:
		member.preview_soul_changed.connect(_on_squad_changed)
	
	_on_squad_changed()

func _on_squad_changed() -> void:
	for _i in data.agent.squad.members.size():
		var member = data.agent.squad.members[_i]
		var chart = %Charts.get_child(_i)
		chart.data = member.preview_soul.chart

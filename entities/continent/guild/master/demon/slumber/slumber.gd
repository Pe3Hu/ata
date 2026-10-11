class_name Slumber
extends Task


func connect_signals() -> void:
	super.connect_signals()
	%Elite.set_gloom(data.rift.gloom)
	_update_turnpike()
	
	for member in data.agent.squad.members:
		member.preview_soul_changed.connect(_on_squad_changed)
	
	data.agent.squad.members_reordered.connect(_on_squad_changed)
	_on_squad_changed()

func _update_turnpike() -> void:
	var gloom = data.rift.gloom
	if gloom.is_elite and Catalog.turnpike_elements.has(gloom.element):
		%Turnpike.update()
	else:
		%Turnpike.visible = false

func _on_squad_changed() -> void:
	var show_charts = data.can_fill_squad()
	%Charts.visible = show_charts
	if not show_charts: return
	
	for _i in data.agent.squad.members.size():
		var member = data.agent.squad.members[_i]
		if member.preview_soul == null: continue
		var chart = %Charts.get_child(_i)
		chart.data = member.preview_soul.chart

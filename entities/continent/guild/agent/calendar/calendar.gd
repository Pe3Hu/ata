class_name Calendar
extends PanelContainer


@export var agent: Agent

const TEX_LOCK_NORMAL := preload("uid://dyhnuea3y1a4l")
const TEX_LOCK_HOVER  := preload("uid://b72sd1i2dgnu1")
const TEX_FREE_NORMAL := preload("uid://b8733ha1tlasv")
const TEX_FREE_HOVER  := preload("uid://dm8qufe13tojk")


func _ready() -> void:
	connect_signals()
	_apply(false)

func connect_signals() -> void:
	if not Mother.mainland.footprint.route_finished.is_connected(update_visible):
		Mother.mainland.footprint.route_finished.connect(update_visible)

func _on_button_pressed() -> void:
	if agent == null or agent.data == null: return
	if not Mother.mainland.route.is_calendar(): return
	if agent.data.workload.current_progress > 0: return

	# кнопка действует на весь отряд по текущим preview
	if agent.data.is_preview_committed():
		agent.data.unassign()
	else:
		agent.data.assign_squad()

	agent.update_view()
	update_textures()

func update_textures() -> void:
	if agent == null or agent.data == null:
		_apply(false)
		return
	
	_apply(agent.data.is_preview_committed())

func update_visible() -> void:
	visible = Mother.mainland.route.is_calendar()
	update_colors()

func _apply(locked_: bool) -> void:
	update_visible()

	if locked_:
		%Button.texture_normal = TEX_LOCK_NORMAL
		%Button.texture_hover  = TEX_LOCK_HOVER
	else:
		%Button.texture_normal = TEX_FREE_NORMAL
		%Button.texture_hover  = TEX_FREE_HOVER

func update_colors() -> void:
	if agent == null or agent.data == null: return
	var preview = agent.data.get_preview()
	if preview == null: return
	Helper.update_matter_colors(%Button, [preview.matter])

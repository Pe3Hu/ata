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
	if agent.data.workload.current_progress > 0: return

	if agent.preview_origin != null and agent.preview_origin.task == agent.data.task:
		agent.data.unassign()
	else:
		agent.data.assign(agent.preview_origin)

	agent.update_view()
	update_textures()

func update_textures() -> void:
	if agent == null or agent.data == null:
		_apply(false)
		return
	
	_apply(agent.preview_origin != null and agent.preview_origin.task == agent.data.task)

func update_visible() -> void:
	visible = Mother.mainland.route.is_calendar()

func _apply(locked_: bool) -> void:
	update_visible()

	if locked_:
		%Button.texture_normal = TEX_LOCK_NORMAL
		%Button.texture_hover  = TEX_LOCK_HOVER
	else:
		%Button.texture_normal = TEX_FREE_NORMAL
		%Button.texture_hover  = TEX_FREE_HOVER

func apply_matter(matter_: Bozo.Matter) -> void:
	Helper.update_matter_colors(%Button, [matter_])

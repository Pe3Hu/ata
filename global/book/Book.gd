extends Node

## Plays Stage objects one after another.
## When a stage fires, the game pauses, Focus aims at the stage target,
## and a text panel with a Continue button is shown.
## Continue hides the focus, the text and the button, then resumes the game.


const brief_scene = preload("uid://cnio0cmn3p1sf")

var _stages: Array = []
var _index := -1
var _current: Stage
var _open := false
var _tree_was_paused := false
var _gear_was_paused := false
var _brief: Brief


func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	_brief = brief_scene.instantiate()
	add_child(_brief)
	_brief.continued.connect(continue_current)

	var stages := Tutorial.stages()
	if not stages.is_empty():
		play(stages)


func play(stages: Array) -> void:
	_stages = stages
	_index = -1
	_open = false
	_current = null
	_advance()


func continue_current() -> void:
	if not _open:
		return

	_open = false
	Focus.disallow(_brief.panel)
	Focus.release()
	_brief.hide_text()
	_set_paused(false)

	if _current:
		_current.finished.emit()
	_advance()


func _advance() -> void:
	_index += 1
	if _index >= _stages.size():
		_current = null
		return

	_current = _stages[_index]
	if not _current.triggered.is_connected(_present):
		_current.triggered.connect(_present, CONNECT_ONE_SHOT)
	_current.arm()


func _present() -> void:
	if _open or _current == null:
		return

	_open = true
	var resolved = _current.resolve_target()

	if resolved is StructureData:
		_frame_structure(resolved)

	_set_paused(true)

	if resolved != null:
		Focus.aim(resolved)

	_brief.show_text(_current.text, Focus.aimed_rect())
	Focus.allow(_brief.panel)


func _set_paused(paused: bool) -> void:
	if paused:
		_tree_was_paused = get_tree().paused
		_gear_was_paused = Gear.is_pause
		get_tree().paused = true
		Gear.is_pause = true
		return

	get_tree().paused = _tree_was_paused
	Gear.is_pause = _gear_was_paused


func _frame_structure(structure: StructureData) -> void:
	var mainland := get_tree().root.find_child("Mainland", true, false) as Mainland
	if mainland == null or mainland.camera == null:
		return

	var camera := mainland.camera
	var point := Helper.get_structure_position(structure, true)
	var smoothing := camera.position_smoothing_enabled
	camera.target_position = point
	camera.position_smoothing_enabled = false
	camera.global_position = point
	camera.reset_smoothing()
	camera.position_smoothing_enabled = smoothing

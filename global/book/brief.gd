class_name Brief
extends CanvasLayer


signal continued

@onready var panel: PanelContainer = %Panel
@onready var _label: Label = %Text
@onready var _button: Button = %Continue


func _on_continue_pressed() -> void:
	continued.emit()


func show_text(text: String, anchor: Rect2 = Rect2()) -> void:
	_label.text = text
	# Size is locked before the layer is shown. A hidden autowrap label has
	# width 0, so its minimum height becomes the whole text stacked vertically.
	var panel_size := _fit_content()
	_lock_panel_size(panel_size)
	visible = true
	_place_under(anchor, panel_size)


func hide_text() -> void:
	visible = false


func _place_under(anchor: Rect2, panel_size: Vector2) -> void:
	const EDGE := 16.0
	const GAP := 16.0

	var view := get_viewport().get_visible_rect()
	var center_x := anchor.get_center().x if anchor.has_area() else view.get_center().x
	var y := anchor.end.y + GAP if anchor.has_area() else view.get_center().y
	var x := center_x - panel_size.x * 0.5

	var min_x := view.position.x + EDGE
	var max_x := view.end.x - EDGE - panel_size.x
	x = x if max_x < min_x else clampf(x, min_x, max_x)

	var max_y := view.end.y - EDGE - panel_size.y
	if y + panel_size.y > view.end.y - EDGE:
		y = max_y
	if anchor.has_area():
		y = maxf(y, anchor.end.y + GAP)

	_lock_panel_size(panel_size)
	panel.global_position = Vector2(x, y)
	_lock_panel_size(panel_size)


func _lock_panel_size(panel_size: Vector2) -> void:
	panel.set_anchors_preset(Control.PRESET_TOP_LEFT)
	panel.grow_horizontal = Control.GROW_DIRECTION_END
	panel.grow_vertical = Control.GROW_DIRECTION_END
	panel.custom_minimum_size = panel_size
	panel.custom_maximum_size = panel_size
	panel.size = panel_size


func _fit_content() -> Vector2:
	var margin := 24.0
	var separation := 20.0
	var max_width := 440.0
	var inner_limit := max_width - margin * 2.0

	var label_font := _label.get_theme_font("font")
	var label_size := _label.get_theme_font_size("font_size")
	if label_font == null:
		label_font = ThemeDB.fallback_font
		label_size = ThemeDB.fallback_font_size

	var text_size := label_font.get_multiline_string_size(
		_label.text, HORIZONTAL_ALIGNMENT_CENTER, inner_limit, label_size
	)

	var button_font := _button.get_theme_font("font")
	var button_size := _button.get_theme_font_size("font_size")
	if button_font == null:
		button_font = label_font
		button_size = label_size
	var button_text := button_font.get_string_size(
		_button.text, HORIZONTAL_ALIGNMENT_CENTER, -1, button_size
	)

	var inner_w := maxf(text_size.x, button_text.x + 32.0)
	var button_h := 52.0
	# Autowrap minimum height uses the control width. While the layer is hidden
	# that width is 0, so the label must be given a real width before layout.
	_label.autowrap_mode = TextServer.AUTOWRAP_OFF
	_label.custom_minimum_size = Vector2(inner_w, text_size.y)
	_label.size = Vector2(inner_w, text_size.y)
	_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	_button.custom_minimum_size = Vector2(inner_w, button_h)
	_button.custom_maximum_size = Vector2(inner_w, button_h)
	return Vector2(inner_w + margin * 2.0, text_size.y + separation + button_h + margin * 2.0)

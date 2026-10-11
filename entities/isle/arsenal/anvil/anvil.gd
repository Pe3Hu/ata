class_name Anvil
extends PanelContainer


var data: AnvilData:
	set(value_):
		data = value_
		connect_datas()

@export var arsenal: Arsenal

@export var old_echos: Array[Echo]


func connect_datas() -> void:
	for _i in data.echos.size():
		var echo = old_echos[_i]
		echo.data = data.echos[_i]
		echo.visible = true
	
	%NewEcho.data = data.new_echo
	%PreviousButton.visible = data.arsenal.anvils.size() > 1
	%NextButton.visible = data.arsenal.anvils.size() > 1
	update_fusion()

func update_fusion() -> void:
	var matters = [data.new_echo.soul.matter]
	Helper.update_matter_colors(%FusionButton, matters)
	var n = data.echos.size()
	var texture = load('res://entities/isle/arsenal/anvil/images/%d/body.png' % n)
	%FusionButton.texture_normal = texture
	%FusionButton.texture_hover = texture
	%FusionButton.texture_pressed = texture
	%FusionBorder.texture =  load('res://entities/isle/arsenal/anvil/images/%d/border.png' % n)

func _on_fusion_button_pressed() -> void:
	data.fusion()

func _on_previous_button_pressed() -> void:
	arsenal.shift_anvil(1)

func _on_next_button_pressed() -> void:
	arsenal.shift_anvil(1)

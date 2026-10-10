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
	%PreviousButton.visible = data.arsenal.anvils.size() > 0
	%PreviousButton.visible = data.arsenal.anvils.size() > 0
	pass

func _on_fusion_button_pressed() -> void:
	data.fusion()

func _on_previous_button_pressed() -> void:
	arsenal.shift_anvil(1)

func _on_next_button_pressed() -> void:
	arsenal.shift_anvil(1)

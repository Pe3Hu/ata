class_name Arsenal
extends PanelContainer


var anvil_scene = preload("uid://bf50ul084wkr1")

var data: ArsenalData:
	set(value_):
		data = value_
		
		connect_signals()

@export var nightmare: Nightmare

var current_anvil_index: int = 0:
	set(value_):
		var anvil
		
		if %Anvils.get_child_count() > current_anvil_index:
			anvil = %Anvils.get_child(current_anvil_index)
			anvil.visible = false
		
		current_anvil_index = value_
		
		if %Anvils.get_child_count() > current_anvil_index:
			anvil = %Anvils.get_child(current_anvil_index)
			anvil.visible = true

#region init
func connect_signals() -> void:
	data.fusion_phase.connect(_on_fusion_phase)
	data.phase_finished.connect(_on_phase_finished)

func _on_fusion_phase() -> void:
	Helper.clear_children(%Anvils)
	if data.anvils.is_empty(): return
	visible = true
	nightmare.odeum.visible = false
	nightmare.house.visible = false
	
	for anvil_data in data.anvils:
		add_anvil(anvil_data)
	
	current_anvil_index = 0

func add_anvil(anvil_data: AnvilData) -> void:
	var anvil = anvil_scene.instantiate()
	%Anvils.add_child(anvil)
	anvil.arsenal = self
	anvil.data = anvil_data

func _on_phase_finished() -> void:
	visible = false
	nightmare.odeum.visible = true
	nightmare.house.visible = true
	Helper.clear_children(%Anvils)
	
	nightmare.house.parlor.reset_cards()
	nightmare.house.kitchen.reset_cards()
	nightmare.house.bedroom.reset_cards()
	Mother.odeum.locked_echos.clear()
#endregion

func shift_anvil(shift_: int) -> void:
	var n = %Anvils.get_child_count()
	current_anvil_index = (current_anvil_index + shift_ + n) % n

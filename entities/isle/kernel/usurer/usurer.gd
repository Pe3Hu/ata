class_name Usurer
extends PanelContainer


var data: UsurerData:
	set(value_):
		data = value_
		
		connect_signals()
		connect_datas()

@export var kernel: Kernel

@export var gas: Debt
@export var liquid: Debt
@export var solid: Debt

var debt_tween: Tween


#region init
func connect_signals() -> void:
	data.update_debts.connect(_on_update_debts)

func _on_update_debts() -> void:
	var duration = Gear.debts[Gear.tempo]
	debt_tween = create_tween().set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_SPRING).set_parallel(true)
	
	for debt in data.debts:
		if debt.current_value != debt.next_value:
			debt_tween.tween_property(debt, "current_value", debt.next_value, duration)

func connect_datas() -> void:
	gas.data = data.matter_to_debt[Bozo.Matter.GAS]
	liquid.data = data.matter_to_debt[Bozo.Matter.LIQUID]
	solid.data = data.matter_to_debt[Bozo.Matter.SOLID]
#endregion

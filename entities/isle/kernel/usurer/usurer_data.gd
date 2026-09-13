class_name UsurerData
extends RefCounted


signal update_debts
signal delcare_bankruptcy

var kernel: KernelData

var debts: Array[DebtData]
var matter_to_debt: Dictionary


#region init
func _init(kernel_: KernelData) -> void:
	kernel = kernel_
	
	delcare_bankruptcy.connect(_on_delcare_bankruptcy)
	init_debts()

func _on_delcare_bankruptcy() -> void:
	kernel.pie.show_shopping()
	kernel.faction.declare_gameover.emit()

func init_debts() -> void:
	for matter in Catalog.matters:
		var _debt = DebtData.new(self, matter)
#endregion

func borrow(matter_: Bozo.Matter, value_: int) -> void:
	if value_ != 0:
		var debt = matter_to_debt[matter_]
		debt.next_value += value_
		update_debts.emit()

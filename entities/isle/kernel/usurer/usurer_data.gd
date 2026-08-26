class_name UsurerData
extends RefCounted


signal update_debts

var kernel: KernelData

var debts: Array[DebtData]
var matter_to_debt: Dictionary


func _init(kernel_: KernelData) -> void:
	kernel = kernel_
	
	init_debts()

func init_debts() -> void:
	for matter in Catalog.matters:
		var _debt = DebtData.new(self, matter)

func borrow(matter_: Bozo.Matter, value_: int) -> void:
	if value_ != 0:
		var debt = matter_to_debt[matter_]
		debt.next_value += value_
		update_debts.emit()

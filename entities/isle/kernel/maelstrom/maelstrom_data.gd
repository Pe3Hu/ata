class_name MaelstromData
extends RefCounted


signal eddy_focused

var kernel: KernelData

var eddies: Array[EddyData]
var element_to_eddy: Dictionary

var focused_eddy: EddyData:
	set(value_):
		focused_eddy = value_
		eddy_focused.emit()


func _init(kernel_: KernelData) -> void:
	kernel = kernel_
	
	init_eddies()

func init_eddies() -> void:
	for element in Catalog.elements:
		EddyData.new(self, element)

func focus_on_element(element_: Bozo.Element = Bozo.Element.NONE) -> void:
	if element_ == Bozo.Element.NONE:
		focused_eddy = null
		return
	
	focused_eddy = element_to_eddy[element_]

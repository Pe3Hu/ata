class_name MaelstromData
extends RefCounted


var kernel: KernelData

var eddies: Array[EddyData]
var element_to_eddy: Dictionary


func _init(kernel_: KernelData) -> void:
	kernel = kernel_
	
	init_eddies()

func init_eddies() -> void:
	for element in Catalog.elements:
		var _eddy = EddyData.new(self, element)

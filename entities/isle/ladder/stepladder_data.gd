class_name StepladderData
extends RefCounted


signal volume_changed
signal pressure_changed

var kernel: KernelData
var flux: FluxData:
	set(value_):
		flux = value_
		
		if flux:
			flux.stepladder = self
		
		volume_changed.emit()
var pressure: PressureData:
	set(value_):
		pressure = value_
		
		if pressure:
			pressure_changed.emit()

func _init(kernel_: KernelData) -> void:
	kernel = kernel_

func finish_pressure() -> void:
	flux = null
	pressure = null

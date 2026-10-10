class_name ShadowData
extends RefCounted


@warning_ignore("unused_signal")
signal is_perished

var echo: EchoData
var pressure: PressureData
var shade: ShadeData

var perfect_cantos: Array[CantoData]
var action: ActionData


func _init(echo_: EchoData) -> void:
	echo = echo_
	
	pressure = PressureData.new()
	pressure.shadow = self
	shade = ShadeData.new(self)

func reset() -> void:
	perfect_cantos.clear()
	shade.reset()
	action = null
	pressure.roll_element()

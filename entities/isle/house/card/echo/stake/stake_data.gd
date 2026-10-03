class_name StakeData
extends RefCounted


signal canto_changed
signal is_voiced_changed

var echo: EchoData
var type: Bozo.Stake
var tune: Bozo.Tune
var joints: Array[int]
var value: int

var canto: CantoData:
	set(value_):
		canto = value_
		canto_changed.emit()

var is_voiced: bool = false:
	set(value_):
		is_voiced = value_
		is_voiced_changed.emit()


func _init(echo_: EchoData, tune_: Bozo.Tune, joints_: Array, value_: int) -> void:
	echo = echo_
	tune = tune_
	joints.append_array(joints_)
	value = value_
	
	type = Digest.tune_to_stake[tune]
	echo.type_to_stakes[type].append(self)
	echo.tune_to_stakes[tune].append(self)
	
	for joint in joints:
		if not echo.joint_to_type_to_stakes.has(joint):
			echo.joint_to_type_to_stakes[joint] = {}
		
		echo.joint_to_type_to_stakes[joint][type] = self

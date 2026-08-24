class_name StakeData
extends RefCounted


signal canto_changed

var stamp: StampData
var type: Bozo.Stake
var tune: Bozo.Tune
var joints: Array[int]
var value: int

var canto: CantoData:
	set(value_):
		canto = value_
		canto_changed.emit()


func _init(stamp_: StampData, tune_: Bozo.Tune, joints_: Array, value_: int) -> void:
	stamp = stamp_
	tune = tune_
	joints.append_array(joints_)
	value = value_
	
	type = Digest.tune_to_stake[tune]
	stamp.type_to_stakes[type].append(self)
	stamp.tune_to_stakes[tune].append(self)
	
	for joint in joints:
		if not stamp.joint_to_type_to_stakes.has(joint):
			stamp.joint_to_type_to_stakes[joint] = {}
		
		stamp.joint_to_type_to_stakes[joint][type] = self

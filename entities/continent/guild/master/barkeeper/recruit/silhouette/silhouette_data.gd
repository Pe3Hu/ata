class_name SilhouetteData
extends RefCounted


var recruit: RecruitData
var stamp: StampData


func _init(recruit_: RecruitData, stamp_: StampData) -> void:
	recruit = recruit_
	stamp = stamp_
	
	recruit.silhouettes.append(self)

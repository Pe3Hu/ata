class_name SilhouetteData
extends RefCounted


var recruit: RecruitData
var echo: EchoData


func _init(recruit_: RecruitData, echo_: EchoData) -> void:
	recruit = recruit_
	echo = echo_
	
	recruit.silhouettes.append(self)

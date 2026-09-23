class_name RecruitData
extends RefCounted


var origin: OriginData
var silhouettes: Array[SilhouetteData]


func _init(origin_: OriginData) -> void:
	origin = origin_
	
	init_silhouettes()

func init_silhouettes() -> void:
	for stamp in origin.stamps:
		var _silhouette = SilhouetteData.new(self, stamp)
	
	var half = silhouettes.size() * 0.5
	var order: Dictionary
	
	for _i in silhouettes.size():
		order[silhouettes[_i]] = _i

	silhouettes.sort_custom(func(a, b):
		var ia = order[a]
		var ib = order[b]
		var ka = ia * 2 if ia < half else (ia - half) * 2 + 1
		var kb = ib * 2 if ib < half else (ib - half) * 2 + 1
		return ka < kb
	)

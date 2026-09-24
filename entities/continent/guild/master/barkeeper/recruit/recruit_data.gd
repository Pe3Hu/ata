class_name RecruitData
extends RefCounted


var barkeeper: BarkeeperData
var origin: OriginData
var silhouettes: Array[SilhouetteData]

var tribute: TributeData


func _init(barkeeper_: BarkeeperData, origin_: OriginData) -> void:
	barkeeper = barkeeper_
	origin = origin_
	
	init_silhouettes()
	init_tribute()

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

func init_tribute() -> void:
	var rank = Catalog.ranks.find(origin.rank) + 1
	var price = Digest.master_to_price[barkeeper.type] * rank
	var volumes = Digest.master_to_volumes[barkeeper.type]
	tribute = TributeData.new(price, volumes)
	
	if Digest.master_to_matter.has(barkeeper.type):
		var matter = Digest.master_to_matter[barkeeper.type]
		tribute.quotums = tribute.quotums.filter(func (a): return a.shard.matter == matter)
		tribute.current_quotum = tribute.quotums.front()

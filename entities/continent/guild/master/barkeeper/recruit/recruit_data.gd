class_name RecruitData
extends TaskData


var master: MasterData
var origin: OriginData
var silhouettes: Array[SilhouetteData]

var tribute: TributeData


func _init(master_: MasterData, origin_: OriginData) -> void:
	master = master_
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
	var price = Digest.master_to_price[master.type] * rank
	var volumes = Digest.master_to_volumes[master.type]
	tribute = TributeData.new(price, volumes)
	
	if Digest.master_to_matter.has(master.type):
		var matter = Digest.master_to_matter[master.type]
		tribute.quotums = tribute.quotums.filter(func (a): return a.shard.matter == matter)
		tribute.current_quotum = tribute.quotums.front()

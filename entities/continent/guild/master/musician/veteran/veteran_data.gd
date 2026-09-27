class_name VeteranData
extends RecruitData



func _init(master_: MasterData, origin_: OriginData) -> void:
	master = master_
	origin = origin_
	
	init_silhouettes()
	init_tribute()

func init_tribute() -> void:
	var rank = Catalog.ranks.find(origin.rank) + 1
	var price = Digest.master_to_price[master.type] * rank
	var volumes = Digest.master_to_volumes[master.type]
	tribute = TributeData.new(price, volumes)
	
	if Digest.master_to_matter.has(master.type):
		var matter = Digest.master_to_matter[master.type]
		tribute.quotums = tribute.quotums.filter(func (a): return a.shard.matter == matter)
		tribute.current_quotum = tribute.quotums.front()

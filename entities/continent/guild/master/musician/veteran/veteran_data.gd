class_name VeteranData
extends RecruitData


var musician: MusicianData


func _init(musician_: MusicianData, origin_: OriginData) -> void:
	musician = musician_
	origin = origin_
	
	init_silhouettes()
	init_tribute()

func init_tribute() -> void:
	var rank = Catalog.ranks.find(origin.rank) + 1
	var price = Digest.master_to_price[musician.type] * rank
	var volumes = Digest.master_to_volumes[musician.type]
	tribute = TributeData.new(price, volumes)
	
	if Digest.master_to_matter.has(musician.type):
		var matter = Digest.master_to_matter[musician.type]
		tribute.quotums = tribute.quotums.filter(func (a): return a.shard.matter == matter)
		tribute.current_quotum = tribute.quotums.front()

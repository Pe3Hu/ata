class_name VeteranData
extends RecruitData



func init_tributes() -> void:
	order = Catalog.ranks.find(soul.rank) + 1
	var price = Digest.master_to_price[master.type] * order
	var volumes = Digest.master_to_volumes[master.type]
	var tribute = TributeData.new(price, volumes)
	
	if Digest.master_to_matter.has(master.type):
		var matter = Digest.master_to_matter[master.type]
		tribute.quotums = tribute.quotums.filter(func (a): return a.shard.matter == matter)
		tribute.current_quotum = tribute.quotums.front()
	
	tributes = [tribute]

func _on_finished() -> void:
	ascension()
	super._on_finished()

func ascension() -> void:
	Mother.guild.souls.erase(agent.squad.members.front().virtual_soul)
	Mother.guild.souls.append(soul)
	restatic()

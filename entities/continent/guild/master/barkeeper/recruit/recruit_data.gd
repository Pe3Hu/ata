class_name RecruitData
extends TaskData


var soul: SoulData
var silhouettes: Array[SilhouetteData]


#region init
func _init(master_: MasterData, order_: int, soul_: SoulData) -> void:
	soul = soul_
	super._init(master_, order_)
	
	init_silhouettes()

func init_silhouettes() -> void:
	for echo in soul.echos:
		var _silhouette = SilhouetteData.new(self, echo)
	
	var half = silhouettes.size() * 0.5
	var silhouette_to_index: Dictionary
	
	for _i in silhouettes.size():
		silhouette_to_index[silhouettes[_i]] = _i

	silhouettes.sort_custom(func(a, b):
		var ia = silhouette_to_index[a]
		var ib = silhouette_to_index[b]
		var ka = ia * 2 if ia < half else (ia - half) * 2 + 1
		var kb = ib * 2 if ib < half else (ib - half) * 2 + 1
		return ka < kb
	)

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
#endregion

func _on_finished() -> void:
	reinforcement()
	super._on_finished()

func reinforcement() -> void:
	Mother.guild.barkeeper.recruiment_phase(soul)
	restatic()

func restatic() -> void:
	var types = [Bozo.Master.MUSICIAN]
	if types.has(master.guild.current_master.type):
		master.guild.current_master.init_static_tasks()

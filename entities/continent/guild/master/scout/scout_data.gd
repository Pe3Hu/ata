class_name ScoutData
extends MasterData


signal extrenals_changed

var extrenals: Array[ShelterData] = []
var internals: Array[ShelterData] = []


#region init
func _init(guild_: GuildData, type_: Bozo.Master) -> void:
	super._init(guild_, type_)
	
	init_internals()

func init_internals() -> void:
	for index in Catalog.center_shelter_indexs:
		var shelter = Mother.mainland.shelters[index]
		add_internal(shelter)

func add_internal(shelter_: ShelterData) -> void:
	if extrenals.has(shelter_):
		extrenals.erase(shelter_)
	
	for neighbor in shelter_.neighbor_shelters:
		if not internals.has(neighbor) and not extrenals.has(neighbor):
			extrenals.append(neighbor)
	
	internals.append(shelter_)
	sort_extrenals()

func remove_internal(shelter_: ShelterData) -> void:
	extrenals = extrenals.filter(func (a): return not shelter_.neighbor_shelters.has(a))
	
	if internals.has(shelter_):
		internals.erase(shelter_)
	
	extrenals.append(shelter_)
	sort_extrenals()

func sort_extrenals() -> void:
	if extrenals.size() < 3:
		extrenals_changed.emit()
		return
	
	var center := Vector2.ZERO
	for shelter in extrenals:
		center += Helper.get_cluster_position(shelter)
	center /= extrenals.size()
	
	extrenals.sort_custom(func(a, b):
		var pa = Helper.get_cluster_position(a) - center
		var pb = Helper.get_cluster_position(b) - center
		return pa.angle() < pb.angle()
	)
	
	extrenals_changed.emit()

func init_tasks() -> void:
	for extrenal in extrenals:
		SpotlightData.new(self, 1, extrenal)
#endregion

class_name ScoutData
extends MasterData


signal spotlight_changed

var extrenals: Array[ShelterData]
var internals: Array[ShelterData]
var spotlights: Array[SpotlightData]

var current_spotlight: SpotlightData:
	set(value_):
		current_spotlight = value_
		spotlight_changed.emit()


#region init
func _init(guild_: GuildData) -> void:
	super._init(guild_)
	
	init_internals()

func init_internals() -> void:
	for index in Catalog.center_shelter_indexs:
		var shelter = Mother.mainland.shelters[index]
		add_internal(shelter)

func add_internal(shelter_: ShelterData) -> void:
	for neighbor in shelter_.neighbor_shelters:
		if not internals.has(neighbor):
			extrenals.append(neighbor)
	
	if extrenals.has(shelter_):
		extrenals.erase(shelter_)
	
	internals.append(shelter_)
	sort_extrenals()

func remove_internal(shelter_: ShelterData) -> void:
	extrenals = extrenals.filter(func (a): return not shelter_.neighbor_shelters.has(a))
	
	if internals.has(shelter_):
		internals.erase(shelter_)
	
	extrenals.append(shelter_)
	sort_extrenals()

func sort_extrenals() -> void:
	if extrenals.size() < 3: return
	
	var positions := PackedVector2Array()
	for shelter in extrenals:
		positions.append(Helper.get_cluster_position(shelter))
	
	var hull := Geometry2D.convex_hull(positions)
	if hull.is_empty(): return
	
	var position_to_shelter: Dictionary
	for shelter in extrenals:
		position_to_shelter[Helper.get_cluster_position(shelter)] = shelter
	
	var sorted: Array[ShelterData]
	sorted.resize(hull.size())
	
	for _i in hull.size():
		var shelter: ShelterData = position_to_shelter.get(hull[_i])
		if shelter:
			sorted[_i] = shelter
	
	extrenals = sorted

func init_spotlights() -> void:
	spotlights.clear()
	
	for extrenal in extrenals:
		SpotlightData.new(self, extrenal)
	
	current_spotlight = spotlights.front()
#endregion

func changed_spotlight(shift_: int) -> void:
	var index = spotlights.find(current_spotlight)
	var n = spotlights.size()
	index = (index + shift_ + n) % n
	current_spotlight = spotlights[index]

class_name RouteData
extends RefCounted


signal trods_updated

var mainland: MainlandData
var start_structure: StructureData:
	set(value_):
		start_structure = value_
		recalc_trods()
var finish_structure: StructureData:
	set(value_):
		finish_structure = value_
		recalc_trods()

var main_trods: Array[TrodData]
var collateral_trods: Array[TrodData]


#region init
func _init(mainland_: MainlandData) -> void:
	mainland = mainland_

func recalc_trods() -> void:
	if start_structure == null or finish_structure == null: return
	reset_trods()
	
	var current_structure = start_structure
	var counter = 30
	
	while current_structure != finish_structure and counter > 0:
		current_structure = choose_trod(current_structure)
		counter -= 1
	
	for trod in main_trods:
		trod.type = Bozo.Trod.MAIN
	
	for trod in collateral_trods:
		trod.type = Bozo.Trod.COLLATERAL
	
	trods_updated.emit()

func reset_trods() -> void:
	for trod in main_trods:
		trod.type = Bozo.Trod.NONE
	for trod in collateral_trods:
		trod.type = Bozo.Trod.NONE
	
	trods_updated.emit()
	main_trods.clear()
	collateral_trods.clear()

func choose_trod(current_structure_: StructureData) -> StructureData:
	if current_structure_ == finish_structure: return
	#var current_distance = current_structure_.coord.distance_to(finish_structure.coord)
	var options = current_structure_.trod_to_structure.keys()
	options.sort_custom(func (a, b): return current_structure_.trod_to_structure[a].get_global_coord().distance_to(finish_structure.get_global_coord()) < current_structure_.trod_to_structure[b].get_global_coord().distance_to(finish_structure.get_global_coord()))
	options = options.filter(func (a): return current_structure_.trod_to_structure[a].get_global_coord().distance_to(finish_structure.get_global_coord()) == current_structure_.trod_to_structure[options.front()].get_global_coord().distance_to(finish_structure.get_global_coord()))
	var trod = options.front()
	main_trods.append(trod)
	#current_structure_ = current_structure_.trod_to_structure[trod]
	#1print([current_structure_.get_global_coord()])
	return current_structure_.trod_to_structure[trod]

func set_structure(structure_: StructureData) -> void:
	if start_structure == null:
		#print([null, structure_.get_global_coord()])
		start_structure = structure_
		return
	
	#print([start_structure.get_global_coord(), structure_.get_global_coord()])
	finish_structure = structure_

func activate() -> void:
	if mainland.footprint.target_structure == null: return
	if start_structure == mainland.footprint.target_structure:
		reset_trods()
		start_structure = null
		finish_structure = null
		return
	
	set_structure(mainland.footprint.target_structure)
#endregion

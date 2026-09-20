class_name Mainland
extends Node2D


var shelter_scene = preload('uid://e02t6jxdkjoe')
var wasteland_scene = preload('uid://bu058yt157muq')
var trod_scene = preload('uid://cwsumdih65nu7')

var data: MainlandData:
	set(value_):
		data = value_
		
		connect_datas()
		update_ground_cells()
		init_shelters()
		init_wastelands()
		init_trods()


#region init
func _ready() -> void:
	data = Mother.mainland
	position = Catalog.MAINLAND_COORD_SIZE * 1.5
	#position.y -= Catalog.MAINLAND_COORD_SIZE.y / 3
	#global_position = get_viewport().get_visible_rect().size / 2.0
	#global_position -= Vector2(Catalog.MAINLAND_GRID_SIZE) * Catalog.MAINLAND_COORD_SIZE / 2.0

func connect_datas() -> void:
	%Haze.data = data.haze
	%Beam.data = data.beam
	%Footprint.data = data.footprint

func update_ground_cells() -> void:
	var coast_cells: Array[Vector2i]
	
	for terrain in data.terrain_to_clusters:
		var terrain_index = Digest.terraint_to_index[terrain]
		var cells: Array[Vector2i]

		for cluster_data in data.terrain_to_clusters[terrain]:
			cells.append_array(cluster_data.internals)

		%Ground.set_cells_terrain_connect(cells, 0, terrain_index)
		coast_cells.append_array(cells)
		
	for wasteland_data in data.wastelands:
		var terrain_index = Digest.terraint_to_index[wasteland_data.terrain]
		var biome_index = Catalog.biomes.find(wasteland_data.biome.type)
		var biome_anchor = Catalog.wasteland_anchors[biome_index]
		
		for _i in Catalog.wasteland_pattern_coords.size():
			var coord = wasteland_data.internals.front() + Vector2i.ONE + wasteland_data.pattern_coords[_i]
			var vec = biome_anchor + Catalog.wasteland_pattern_coords[_i]
			%Ground.set_cell(coord, terrain_index, vec)
	
	update_coast_cells(coast_cells)
	#%Coast.set_cells_terrain_connect(coast_cells, 0, 0)

func update_coast_cells(cells_: Array[Vector2i]) -> void:
	var borderlands = Helper.get_borderland_coords(cells_, false)
	cells_.append_array(borderlands)
	%Coast.set_cells_terrain_connect(cells_, 0, 0)

func init_shelters() -> void:
	for shelter_data in data.shelters:
		add_shelter(shelter_data)

func add_shelter(shelter_data_: ShelterData) -> void:
	var shelter = shelter_scene.instantiate()
	%Shelters.add_child(shelter)
	shelter.data = shelter_data_

func init_wastelands() -> void:
	for wasteland_data in data.wastelands:
		add_wasteland(wasteland_data)

func add_wasteland(wasteland_data_: WastelandData) -> void:
	var wasteland = wasteland_scene.instantiate()
	%Wastelands.add_child(wasteland)
	wasteland.data = wasteland_data_

func init_trods() -> void:
	for trod_data in data.trods:
		add_trod(trod_data)

func add_trod(trod_data_: TrodData) -> void:
	var trod = trod_scene.instantiate()
	%Trods.add_child(trod)
	trod.data = trod_data_
#endregion

func _on_continent_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		data.beam.activate()
		#data.footprint.activate()
		data.route.activate()

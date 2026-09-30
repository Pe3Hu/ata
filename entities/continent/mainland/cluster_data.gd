class_name ClusterData
extends RefCounted


var mainland: MainlandData
var terrain: Bozo.Terrain

var internals: Array[Vector2i]
var externals: Array[Vector2i]

var neighbor_shelters: Array[ShelterData]
var neighbor_wastelands: Array[WastelandData]

var center: Vector2
var index: int


func _init(maindland_: MainlandData, anchor_: Vector2i, terrain_: Bozo.Terrain) -> void:
	mainland = maindland_
	terrain = terrain_
	
	init_internals(anchor_)
	calc_center()

func init_internals(anchor_: Vector2i) -> void:
	for x in Digest.terrain_to_cluster_size[terrain]:
		for y in Digest.terrain_to_cluster_size[terrain]:
			var cell = anchor_ + Vector2i(x, y)
			
			if Helper.is_coord_inside_mainland(cell):
				internals.append(cell)
			else:
				return

func calc_center() -> void:
	center = Vector2.ONE / 2
	
	for internal in internals:
		center += Vector2(internal) / internals.size()

func init_externals() -> void:
	externals = Helper.get_borderland_coords(internals, false) 

func link_neighbors() -> void:
	for cell in internals:
		for direction in Catalog.orthogonal_directions:
			var neighbor_coord: Vector2i = cell + direction
			if not mainland.coord_to_cluster.has(neighbor_coord): continue
			var neighbor_cluster = mainland.coord_to_cluster[neighbor_coord]
			if neighbor_cluster == self: continue

			if neighbor_cluster is WastelandData:
				if not neighbor_wastelands.has(neighbor_cluster):
					neighbor_wastelands.append(neighbor_cluster)
			elif neighbor_cluster is ShelterData:
				if not neighbor_shelters.has(neighbor_cluster):
					neighbor_shelters.append(neighbor_cluster)

func count_fog_pixels() -> int:
	if internals.is_empty() or mainland == null or mainland.haze == null:
		return 0
	
	var haze: HazeData = Mother.mainland.haze
	var cell_size: Vector2i = Catalog.MAINLAND_COORD_SIZE
	
	# Находим bounding box всех внутренних ячеек
	var min_c: Vector2i = internals[0]
	var max_c: Vector2i = internals[0]
	for cell in internals:
		min_c.x = mini(min_c.x, cell.x)
		min_c.y = mini(min_c.y, cell.y)
		max_c.x = maxi(max_c.x, cell.x)
		max_c.y = maxi(max_c.y, cell.y)
	
	# Переводим мировые координаты углов в координаты тумана
	var tl: Vector2i = haze.world_to_fog(Vector2(min_c * cell_size))
	var br: Vector2i = haze.world_to_fog(Vector2((max_c + Vector2i.ONE) * cell_size) - Vector2.ONE)
	
	var fog_count: int = 0
	for y in range(tl.y, br.y + 1):
		for x in range(tl.x, br.x + 1):
			if not haze.in_bounds(x, y): continue
			# Туман — это пиксель, у которого красный канал < 0.5
			if haze.fog_image.get_pixel(x, y).r < 0.5:
				fog_count += 1
	
	return fog_count

class_name HazeData
extends RefCounted


signal changed

const NEIGHBORS: Array[Vector2i] = [
	Vector2i(1, 0), Vector2i(-1, 0), Vector2i(0, 1), Vector2i(0, -1)
]

var mainland: MainlandData

var fog_pixelation: int = 8
var fog_color: Color = Color(0.0, 0.0, 0.0, 1.0)
var clear_color: Color = Color(0.0, 0.0, 0.0, 0.0)

var fog_image: Image
var clear_image: Image
var fog_texture: ImageTexture

var width: int = 0
var height: int = 0
var world_position: Vector2 = Vector2.ZERO

# Каждая волна — Dictionary:
#   { "pending": Array[Vector2i], "origin": Vector2, "radius": float,
#     "max_radius": float, "speed": float, "jitter": float }
var _waves: Array[Dictionary] = []
var _delayed: Array[Dictionary] = [] 
# Пауза между стартами соседних wastelands при триггере A (сек).
var neighbor_stagger: float = 0.1

# --- Состояние эрозии (возврат тумана по периферии) ---
var erosion_steps_per_press: int = 3
var erosion_speed_steps_per_sec: float = 15.0

var _frontier: Dictionary = {}       # Vector2i -> true
var _frontier_dirty: bool = true
var _erosion_pending: int = 0
var _erosion_accum: float = 0.0

# --- «Дыхание» периферии (прилив/отлив) ---
# Каждая пара «засвет-граница ↔ туман-граница» имеет:
#   * пространственную фазу spatial = sin(lobes * angle + bias)  (знак =
#     какая сторона границы сейчас вдох, какая — выдох);
#   * собственный порог flip_threshold = hash(pair) ∈ [0,1).
# Пара «переворачивается» из базового состояния, когда
#     |sin(omega*t) * ramp * spatial| > flip_threshold.
# Так как у каждой пары свой порог, а sin() меняется плавно, пары
# переключаются по одной — граница непрерывно «дышит», без рывков.
# Баланс клеток сохраняется: сколько засветилось — столько и затуманилось.
var pulse_enabled: bool = true
var pulse_frequency: float = 0.10                 # Гц — один полный вдох-выдох ~10 с
var pulse_lobes: float = 1.0                      # число антифазных зон
var pulse_lobe_bias: float = 0.0                  # рад — сдвиг зон по кругу
var pulse_amplitude: float = 0.35                 # 0..1 — макс. доля пар на пике
const PULSE_RAMP_DURATION: float = 1.5            # сек — плавный ввод амплитуды
const PULSE_STABLE_DELAY: float = 0.3             # сек — пауза перед стартом

var _pulse_active: bool = false
var _pulse_time: float = 0.0
var _pulse_stable_timer: float = 0.0
var _pulse_pairs: Array[Dictionary] = []
var _pulse_base: Dictionary = {}                  # Vector2i -> bool (базовое состояние)


func _init(mainland_: MainlandData) -> void:
	mainland = mainland_
	generate()


#region lifecycle

func generate() -> void:
	var cell_size: Vector2i = Catalog.MAINLAND_CELL_SIZE

	var world_dimensions: Vector2i = (Catalog.OCEAN_MAX_CELL - Catalog.OCEAN_MIN_CELL + Vector2i.ONE) * cell_size
	world_position = Vector2(Catalog.OCEAN_MIN_CELL * cell_size)

	width = int(ceil(world_dimensions.x / float(fog_pixelation)))
	height = int(ceil(world_dimensions.y / float(fog_pixelation)))

	fog_image = Image.create(width, height, false, Image.Format.FORMAT_RGBA8)
	fog_image.fill(fog_color)

	clear_image = Image.create(width, height, false, Image.Format.FORMAT_RGBA8)
	clear_image.fill(clear_color)

	fog_texture = ImageTexture.create_from_image(fog_image)

	_waves.clear()
	_delayed.clear()
	_frontier.clear()
	_frontier_dirty = true
	_erosion_pending = 0
	_erosion_accum = 0.0

	_pulse_active = false
	_pulse_time = 0.0
	_pulse_stable_timer = 0.0
	_pulse_pairs.clear()
	_pulse_base.clear()

	changed.emit()


func refresh() -> void:
	if fog_texture != null and fog_image != null:
		fog_texture.update(fog_image)
	changed.emit()


# Вызывается из Haze._process каждый кадр.
func tick(delta_: float) -> void:
	@warning_ignore("shadowed_variable")
	var changed := false

	# 1. Если идёт волна/эрозия — снять пульсацию ДО обработки,
	#    чтобы волны работали по чистой базе.
	var busy_pre := not _delayed.is_empty() or not _waves.is_empty() or _erosion_pending > 0
	if busy_pre and _pulse_active:
		if _undo_pulse():
			changed = true

	# 2. Отложенные старты соседей.
	if not _delayed.is_empty():
		var still: Array[Dictionary] = []
		for d in _delayed:
			d["delay"] -= delta_
			if d["delay"] <= 0.0:
				reveal_cluster_wave(d["cluster"], d["duration"],
					d["wave_jitter"], d["edge_jitter"],
					d["include_externals"], d.get("origin"),
					d.get("initial_radius", 0.0))
			else:
				still.append(d)
		_delayed = still

	# 3. Волны и эрозия.
	if not _waves.is_empty() and _tick_waves(delta_):
		changed = true
	if _erosion_pending > 0 and _tick_erosion(delta_):
		changed = true

	# 4. Дыхание периферии — только когда всё стихло.
	var still_busy := not _delayed.is_empty() or not _waves.is_empty() or _erosion_pending > 0
	if not pulse_enabled:
		if _pulse_active:
			if _undo_pulse():
				changed = true
	elif still_busy:
		_pulse_stable_timer = 0.0
	else:
		_pulse_stable_timer += delta_
		if _pulse_stable_timer >= PULSE_STABLE_DELAY:
			if not _pulse_active:
				_start_pulse()
			if _pulse_active:
				_pulse_time += delta_
				if _apply_pulse():
					changed = true

	if changed:
		refresh()
#endregion


#region helper

func in_bounds(x_: int, y_: int) -> bool:
	return x_ >= 0 and y_ >= 0 and x_ < width and y_ < height

func world_to_fog(world_position_: Vector2) -> Vector2i:
	return Vector2i((world_position_ - world_position) / fog_pixelation)

func reveal_pixel(x_: int, y_: int) -> bool:
	if not in_bounds(x_, y_): return false
	if fog_image.get_pixel(x_, y_).r >= 1.0: return false
	clear_image.set_pixel(x_, y_, clear_color)
	fog_image.set_pixel(x_, y_, Color(1.0, fog_color.g, fog_color.b, fog_color.a))
	_frontier_dirty = true
	return true

func _set_revealed(x_: int, y_: int, revealed_: bool) -> void:
	if not in_bounds(x_, y_): return
	if revealed_:
		clear_image.set_pixel(x_, y_, clear_color)
		fog_image.set_pixel(x_, y_, Color(1.0, fog_color.g, fog_color.b, fog_color.a))
	else:
		clear_image.set_pixel(x_, y_, Color(0, 0, 0, 0))
		fog_image.set_pixel(x_, y_, fog_color)
	_frontier_dirty = true

# Стабильный псевдослучайный шум в [0,1) для пары координат.
func _hash01(x_: int, y_: int) -> float:
	var h: int = x_ * 374761393 + y_ * 668265263
	h = (h ^ (h >> 13)) * 1274126177
	h = h ^ (h >> 16)
	return float(h & 0x7fffffff) / float(0x7fffffff)

# Стабильный шум для пары клеток (используется как per-pair порог).
func _pair_hash(c_: Vector2i, f_: Vector2i) -> float:
	return _hash01(c_.x * 7919 + f_.x * 4241, c_.y * 4793 + f_.y * 2753)

func _compute_max_radius(pending_: Array[Vector2i], origin_: Vector2,
		jitter_: float) -> float:
	var max_r := 0.0
	for p in pending_:
		var d := origin_.distance_to(Vector2(p))
		var n := (_hash01(p.x, p.y) - 0.5) * 2.0
		var eff := d + n * jitter_
		if eff > max_r:
			max_r = eff
	return max_r + 1.0
#endregion


#region reveal

# Собирает fog-пиксели, покрывающие кластер.
# include_externals_ = true  → internals + externals (shelter)
# include_externals_ = false → только internals    (wasteland)
# Форма — описанная окружность вокруг bbox, слегка неровная за счёт
# стабильного шума по координатам пикселя.
# Возвращает:
#   { "pixels": Dictionary[Vector2i -> true], "center": Vector2, "radius": float }
func _collect_cluster_circle(cluster_: Variant, edge_jitter_: float,
		include_externals_: bool = true) -> Dictionary:
	var result := {"pixels": {}, "center": Vector2.ZERO, "radius": 0.0}
	if cluster_ == null: return result

	var cells: Array[Vector2i] = []
	cells.append_array(cluster_.internals)
	if include_externals_:
		cells.append_array(cluster_.externals)
	if cells.is_empty(): return result

	var cell_size: Vector2i = Catalog.MAINLAND_CELL_SIZE

	var min_c := Vector2i(1 << 30, 1 << 30)
	var max_c := Vector2i(-(1 << 30), -(1 << 30))
	for cell in cells:
		min_c.x = mini(min_c.x, cell.x)
		min_c.y = mini(min_c.y, cell.y)
		max_c.x = maxi(max_c.x, cell.x)
		max_c.y = maxi(max_c.y, cell.y)

	var tl := world_to_fog(Vector2(min_c * cell_size))
	var br := world_to_fog(Vector2((max_c + Vector2i.ONE) * cell_size) - Vector2.ONE)

	var center := (Vector2(tl) + Vector2(br)) * 0.5
	var half := (Vector2(br) - Vector2(tl)) * 0.5
	var radius := half.length()

	var pad := int(ceil(edge_jitter_)) + 2
	var x0 := int(floor(center.x - radius)) - pad
	var x1 := int(ceil (center.x + radius)) + pad
	var y0 := int(floor(center.y - radius)) - pad
	var y1 := int(ceil (center.y + radius)) + pad

	var pixels: Dictionary = {}
	for y in range(y0, y1 + 1):
		for x in range(x0, x1 + 1):
			if not in_bounds(x, y): continue
			var d := center.distance_to(Vector2(x, y))
			var n := (_hash01(x, y) - 0.5) * 2.0
			var effective := d + n * edge_jitter_
			if effective <= radius:
				pixels[Vector2i(x, y)] = true

	result["pixels"] = pixels
	result["center"] = center
	result["radius"] = radius
	return result


# Мгновенный вариант (для отладки / неанимированных случаев).
func reveal_cluster(cluster_: Variant, edge_jitter_: float = 1.5,
		include_externals_: bool = true) -> void:
	var info := _collect_cluster_circle(cluster_, edge_jitter_, include_externals_)
	var pixels: Dictionary = info["pixels"]
	var any := false
	for p: Vector2i in pixels.keys():
		if reveal_pixel(p.x, p.y):
			any = true
	if any:
		refresh()


# origin_override_   — если задан, волна стартует из этой точки.
# initial_radius_    — стартовый радиус фронта. Для соседей shelter’а
#                      передаётся радиус, на котором shelter закончился —
#                      так фронт получается непрерывным.
#                      duration_ в этом случае трактуется как время от
#                      initial_radius_ до max_radius.
func reveal_cluster_wave(cluster_: Variant, duration_: float = 0.5,
		wave_jitter_: float = 0.8, edge_jitter_: float = 1.5,
		include_externals_: bool = true, origin_override_ = null,
		initial_radius_: float = 0.0) -> void:
	if cluster_ == null: return
	if cluster_ is ShelterData:
		mainland.beam.current_shelter = cluster_
		cluster_.shrine.is_hazed = false
		mainland.footprint.next_structure = cluster_.shrine

	var info := _collect_cluster_circle(cluster_, edge_jitter_, include_externals_)
	var pixels: Dictionary = info["pixels"]
	if pixels.is_empty(): return

	var pending: Array[Vector2i] = []
	for p: Vector2i in pixels.keys():
		pending.append(p)

	var origin: Vector2 = info["center"] if origin_override_ == null else origin_override_
	var max_radius := _compute_max_radius(pending, origin, wave_jitter_)

	# Расстояние, которое волне осталось пройти.
	var dist: float = max(0.0, max_radius - initial_radius_)

	_waves.append({
		"pending": pending,
		"origin": origin,
		"radius": initial_radius_,
		"max_radius": max_radius,
		"speed": dist / max(duration_, 0.01),
		"jitter": wave_jitter_,
	})

# Один шаг по всем активным волнам. Возвращает true, если хоть
# одна волна что-то раскрыла в этом кадре.
func _tick_waves(delta_: float) -> bool:
	var revealed_any := false
	var surviving: Array[Dictionary] = []

	for wave: Dictionary in _waves:
		wave["radius"] += wave["speed"] * delta_
		var pending: Array[Vector2i] = wave["pending"]
		var origin: Vector2 = wave["origin"]
		var radius: float = wave["radius"]
		var jitter: float = wave["jitter"]

		var still: Array[Vector2i] = []
		for p in pending:
			var d := origin.distance_to(Vector2(p))
			var n := (_hash01(p.x, p.y) - 0.5) * 2.0
			var eff := d + n * jitter
			if eff <= radius:
				if reveal_pixel(p.x, p.y):
					revealed_any = true
			else:
				still.append(p)

		wave["pending"] = still

		if not still.is_empty() and wave["radius"] < wave["max_radius"]:
			surviving.append(wave)
		# Иначе — волна завершилась, не переносим её в surviving.

	_waves = surviving
	return revealed_any
#endregion


#region periphery erosion

# Публичный триггер: вызывается из Haze по пробелу.
# steps_ < 0 — использовать erosion_steps_per_press.
#
# ВАЖНО: здесь НЕ перестраиваем frontier. Если пульсация активна,
# undo_pulse() выполнится в tick() уже ПОСЛЕ этого вызова, и только
# тогда состояние стабилизируется. Перестроение frontier откладываем
# до начала реальной эрозии (см. _tick_erosion), чтобы она работала
# по согласованному с изображением состоянию.
func trigger_periphery_erosion(steps_: int = -1) -> void:
	if steps_ < 0:
		steps_ = erosion_steps_per_press
	if steps_ <= 0: return
	_frontier_dirty = true
	_erosion_pending += steps_


func _is_revealed(x_: int, y_: int) -> bool:
	return fog_image.get_pixel(x_, y_).r > 0.5


# Границей считается ТОЛЬКО сосед-пиксель в пределах изображения.
# За картой — не туман, иначе края «съедаются» сами в себя.
func _has_fog_neighbor(x_: int, y_: int) -> bool:
	for d in NEIGHBORS:
		var nx = x_ + d.x
		var ny = y_ + d.y
		if not in_bounds(nx, ny): continue
		if not _is_revealed(nx, ny): return true
	return false


func _mark_frontier(x_: int, y_: int) -> void:
	if _is_revealed(x_, y_) and _has_fog_neighbor(x_, y_):
		_frontier[Vector2i(x_, y_)] = true


func _rebuild_frontier() -> void:
	_frontier.clear()
	for y in range(height):
		for x in range(width):
			_mark_frontier(x, y)


func _refresh_frontier_around(p_: Vector2i) -> void:
	for d in NEIGHBORS:
		var q = p_ + d
		if not in_bounds(q.x, q.y): continue
		_frontier.erase(q)
		_mark_frontier(q.x, q.y)


# Один шаг эрозии: снять один «слой» засветки по всей периферии.
func _erode_step() -> bool:
	if _frontier.is_empty():
		return false

	var to_fog: Array[Vector2i] = []
	for p: Vector2i in _frontier.keys():
		if _is_revealed(p.x, p.y) and _has_fog_neighbor(p.x, p.y):
			to_fog.append(p)

	_frontier.clear()
	if to_fog.is_empty():
		return false

	for p in to_fog:
		clear_image.set_pixel(p.x, p.y, Color(0, 0, 0, 0))
		fog_image.set_pixel(p.x, p.y, fog_color)

	for p in to_fog:
		_refresh_frontier_around(p)

	return true


# Прогресс эрозии. Frontier перестраивается здесь, а не в триггере —
# так мы гарантируем, что undo_pulse() из этого же кадра уже применён,
# и _frontier соответствует актуальному fog_image.
func _tick_erosion(delta_: float) -> bool:
	if _frontier_dirty:
		_rebuild_frontier()
		_frontier_dirty = false
	if _frontier.is_empty():
		_erosion_pending = 0
		_erosion_accum = 0.0
		return false

	_erosion_accum += delta_ * erosion_speed_steps_per_sec
	@warning_ignore("shadowed_variable")
	var changed := false
	while _erosion_accum >= 1.0 and _erosion_pending > 0:
		if not _erode_step():
			_erosion_pending = 0
			_erosion_accum = 0.0
			break
		_erosion_pending -= 1
		_erosion_accum -= 1.0
		changed = true
	return changed

#endregion


#region periphery breathing

# Собирает пары «засвет-граница ↔ туман-граница» по всему периметру.
# Пара — соседние клетки, одна засвечена, другая в тумане.
# Каждая клетка участвует максимум в одной паре.
# Для каждой пары храним:
#   angle  — угол её середины относительно центра пар (для spatial-фазы);
#   thr    — собственный порог переключения [0,1) (для плавной очереди).
func _collect_pulse_pairs() -> void:
	_pulse_pairs.clear()
	_pulse_base.clear()

	var seen_clear: Dictionary = {}
	var seen_fog: Dictionary = {}

	for y in range(height):
		for x in range(width):
			if not _is_revealed(x, y): continue
			var c := Vector2i(x, y)
			if seen_clear.has(c): continue
			for d in NEIGHBORS:
				var nx: int = x + d.x
				var ny: int = y + d.y
				if not in_bounds(nx, ny): continue
				if _is_revealed(nx, ny): continue
				var f := Vector2i(nx, ny)
				if seen_fog.has(f): continue
				seen_clear[c] = true
				seen_fog[f] = true
				_pulse_pairs.append({
					"clear": c, "fog": f, "angle": 0.0,
					"thr": _pair_hash(c, f),
				})
				_pulse_base[c] = true
				_pulse_base[f] = false
				break

	if _pulse_pairs.is_empty(): return

	# Центр пар — для угловой координаты.
	var cx := 0.0
	var cy := 0.0
	for pair: Dictionary in _pulse_pairs:
		var c: Vector2i = pair["clear"]
		var f: Vector2i = pair["fog"]
		cx += (float(c.x) + float(f.x)) * 0.5
		cy += (float(c.y) + float(f.y)) * 0.5
	cx /= float(_pulse_pairs.size())
	cy /= float(_pulse_pairs.size())

	for pair: Dictionary in _pulse_pairs:
		var c: Vector2i = pair["clear"]
		var f: Vector2i = pair["fog"]
		var mx := (float(c.x) + float(f.x)) * 0.5
		var my := (float(c.y) + float(f.y)) * 0.5
		pair["angle"] = atan2(my - cy, mx - cx)


func _start_pulse() -> void:
	_collect_pulse_pairs()
	if _pulse_pairs.is_empty():
		_pulse_active = false
		return
	_pulse_time = 0.0
	_pulse_active = true


# Возвращает true, если что-то изменилось (требуется refresh).
func _undo_pulse() -> bool:
	var any := false
	for cell: Vector2i in _pulse_base.keys():
		var base: bool = _pulse_base[cell]
		if _is_revealed(cell.x, cell.y) != base:
			_set_revealed(cell.x, cell.y, base)
			any = true
	_pulse_pairs.clear()
	_pulse_base.clear()
	_pulse_active = false
	_pulse_time = 0.0
	return any


# Один кадр «дыхания».
#
# time_amp = sin(omega * t) * ramp  — общая временная огибающая (плавно
#                                     меняется каждый кадр);
# spatial  = sin(lobes * angle + bias) — пространственный знак: у одной
#                                     части границы положительный, у
#                                     противоположной — отрицательный
#                                     (антифаза);
# v = time_amp * spatial            — «смещение» для пары;
# thr = pair.thr                    — собственный порог пары.
#
# Пара выходит из базового состояния ровно тогда, когда |v| пересекает
# её порог. Поскольку пороги у пар разные, они переключаются по одной,
# и граница плавно «дышит», а не мигает кадрами.
#
# Баланс: сколько пар ушло в засвет, столько же — в туман.
func _apply_pulse() -> bool:
	var omega := TAU * pulse_frequency
	var t := _pulse_time
	var ramp := minf(1.0, t / PULSE_RAMP_DURATION)
	var time_amp := sin(omega * t) * ramp

	var flip_reveal: Array = []   # [excess, fog_cell]
	var flip_fog: Array = []      # [excess, clear_cell]

	for pair: Dictionary in _pulse_pairs:
		var c: Vector2i = pair["clear"]
		var f: Vector2i = pair["fog"]
		var angle: float = pair["angle"]
		var thr: float = pair["thr"]
		var spatial: float = sin(pulse_lobes * angle + pulse_lobe_bias)
		var v: float = time_amp * spatial
		var av: float = absf(v)
		if av <= thr:
			continue
		var excess: float = av - thr
		if v > 0.0:
			flip_reveal.append([excess, f])
		else:
			flip_fog.append([excess, c])

	var n: int = mini(flip_reveal.size(), flip_fog.size())
	var cap: int = int(float(_pulse_pairs.size()) * clampf(pulse_amplitude, 0.0, 1.0) * 0.5)
	n = mini(n, cap)

	flip_reveal.sort_custom(func(a, b): return a[0] > b[0])
	flip_fog.sort_custom(func(a, b): return a[0] > b[0])

	var target_reveal: Dictionary = {}
	for i in range(n):
		target_reveal[flip_reveal[i][1]] = true
	var target_fog: Dictionary = {}
	for i in range(n):
		target_fog[flip_fog[i][1]] = true

	@warning_ignore("shadowed_variable")
	var changed := false
	for cell: Vector2i in _pulse_base.keys():
		var base: bool = _pulse_base[cell]
		var current: bool = _is_revealed(cell.x, cell.y)
		var target: bool = base
		if target_reveal.has(cell):
			target = true
		elif target_fog.has(cell):
			target = false
		if current != target:
			_set_revealed(cell.x, cell.y, target)
			changed = true
	return changed

#endregion


#region debug-triggers

# Q — первый shelter (internals + externals).
func reveal_current_shelter_wave(duration_: float = 0.5,
		wave_jitter_: float = 0.8, edge_jitter_: float = 1.5) -> void:
	if mainland == null: return
	if mainland.shelters.is_empty(): return
	reveal_cluster_wave(mainland.shelters[0], duration_, wave_jitter_, edge_jitter_, true)


# W — первый wasteland (только internals).
func reveal_current_wasteland_wave(duration_: float = 0.5,
		wave_jitter_: float = 0.8, edge_jitter_: float = 1.5) -> void:
	if mainland == null: return
	if mainland.wastelands.is_empty(): return
	reveal_cluster_wave(mainland.wastelands[0], duration_, wave_jitter_, edge_jitter_, false)


# A — shelter (с externals), затем его соседние wastelands (internals),
# волна каждого wasteland'а расходится ИЗ ЦЕНТРА shelter'а.
func reveal_shelter_then_neighbors_wave(shelter_index_: int = 3,
		duration_: float = 0.5,
		wave_jitter_: float = 0.8,
		edge_jitter_: float = 1.5) -> void:
	if mainland == null: return
	if shelter_index_ < 0 or shelter_index_ >= mainland.shelters.size(): return

	var shelter: ShelterData = mainland.shelters[shelter_index_]

	# Заранее считаем геометрию shelter’а: его центр и радиус, на
	# котором волна остановится. Эти значения нужны для соседей.
	var shelter_info := _collect_cluster_circle(shelter, edge_jitter_, true)
	var shelter_pixels: Dictionary = shelter_info["pixels"]
	if shelter_pixels.is_empty(): return

	var shelter_origin: Vector2 = shelter_info["center"]
	var shelter_pending: Array[Vector2i] = []
	for p: Vector2i in shelter_pixels.keys():
		shelter_pending.append(p)
	var shelter_max_radius := _compute_max_radius(shelter_pending, shelter_origin, wave_jitter_)

	# 1. Shelter — как обычно, из своего центра.
	reveal_cluster_wave(shelter, duration_, wave_jitter_, edge_jitter_, true)

	# 2. Соседи — стартуют ровно в момент окончания shelter’а, из того же
	#    центра, с радиусом, на котором остановился shelter. Фронт
	#    получается непрерывным: где shelter закончил — там сосед начал.
	var t: float = duration_
	for w in shelter.neighbor_wastelands:
		_delayed.append({
			"cluster": w,
			"delay": t,
			"duration": duration_,
			"wave_jitter": wave_jitter_,
			"edge_jitter": edge_jitter_,
			"include_externals": false,
			"origin": shelter_origin,
			"initial_radius": shelter_max_radius,
		})
		t += neighbor_stagger
#endregion

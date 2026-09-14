class_name Refuge
extends Node2D

signal territory_changed(fog_percent: float)

@onready var fog_sprite: Sprite2D = %FogSprite
@onready var ground_tiles: TileMapLayer = %GroundTiles
@onready var player: CharacterBody2D = %Player

var fog_image: Image
var vision_image: Image
var _fog_texture: ImageTexture

var _fog_w: int = 0
var _fog_h: int = 0

@export var fog_pixelation: int = 8

# --- Обычная эрозия (Пробел) ---
@export var erosion_threshold: float = 0.05
@export var erosion_per_press: int = 3
@export var erosion_speed_px_per_sec: float = 15.0

# --- Секторная эрозия (клавиша 2) ---
@export var sector_erosion_per_press: int = 3
@export var sector_erosion_speed_px_per_sec: float = 15.0

# --- Сонар (клавиша 1) ---
@export var sweep_beam_radius_world: float = 400.0
@export var sweep_duration: float = 2.0

# --- Счётчик территории ---
@export var recount_interval: float = 0.1
var territory_percent: float = 100.0

var world_position: Vector2

var _erosion_pending: float = 0.0
var _erosion_accum: float = 0.0

var _sector_pending: float = 0.0
var _sector_accum: float = 0.0
var _sector_center_angle: float = 0.0
var _sector_half_width: float = PI / 8.0
var _sector_origin: Vector2i = Vector2i.ZERO

var _sweep_active: bool = false
var _sweep_angle: float = 0.0
var _sweep_angle_prev: float = 0.0

var _fog_dirty: bool = false
var _recount_timer: float = 0.0

# Фронт: territory-пиксели, граничащие с туманом (кандидаты на эрозию)
var _frontier: Dictionary = {}   # Vector2i -> true

const NEIGHBORS: Array[Vector2i] = [
	Vector2i(1, 0), Vector2i(-1, 0), Vector2i(0, 1), Vector2i(0, -1)
]


func _ready() -> void:
	generate_fog()
	_blend_vision()
	_refresh_fog_texture()
	_recount_territory(true)


func _process(delta: float) -> void:
	# --- Обычная эрозия ---
	if _erosion_pending > 0.0:
		_erosion_accum += delta * erosion_speed_px_per_sec
		var changed = false
		while _erosion_accum >= 1.0 and _erosion_pending > 0.0:
			if not _erode_step():
				_erosion_pending = 0.0
				_erosion_accum = 0.0
				break
			_erosion_pending -= 1.0
			_erosion_accum -= 1.0
			changed = true
		if changed:
			_refresh_fog_texture()

	# --- Секторная эрозия ---
	if _sector_pending > 0.0:
		_sector_accum += delta * sector_erosion_speed_px_per_sec
		var changed = false
		while _sector_accum >= 1.0 and _sector_pending > 0.0:
			if not _erode_step_sector(_sector_center_angle, _sector_half_width, _sector_origin):
				_sector_pending = 0.0
				_sector_accum = 0.0
				break
			_sector_pending -= 1.0
			_sector_accum -= 1.0
			changed = true
		if changed:
			_refresh_fog_texture()

	# --- Сонар ---
	if _sweep_active:
		_sweep_angle_prev = _sweep_angle
		_sweep_angle = min(_sweep_angle + TAU / sweep_duration * delta, TAU)
		if _sweep_from_to(_sweep_angle_prev, _sweep_angle):
			_refresh_fog_texture()
		if _sweep_angle >= TAU:
			_sweep_active = false

	# --- Зрение игрока ---
	if _erosion_pending <= 0.0 and _sector_pending <= 0.0 \
			and player.velocity.length_squared() > 0.0:
		_blend_vision()
		_refresh_fog_texture()

	# --- Пересчёт территории (раз в recount_interval) ---
	if _fog_dirty:
		_recount_timer += delta
		if _recount_timer >= recount_interval:
			_recount_timer = 0.0
			_fog_dirty = false
			_recount_territory()


func _input(event: InputEvent) -> void:
	if event is InputEventKey and event.pressed and not event.echo:
		match event.physical_keycode:
			KEY_SPACE:
				if not _frontier.is_empty():
					_erosion_pending += float(erosion_per_press)
				return
			KEY_1:
				if not _sweep_active:
					_sweep_active = true
					_sweep_angle = 0.0
					_sweep_angle_prev = 0.0
			KEY_2:
				var idx: int = randi() % 8
				_sector_center_angle = float(idx) * TAU / 8.0
				_sector_half_width = PI / 8.0
				_sector_origin = _world_to_fog(player.global_position)
				_sector_pending += float(sector_erosion_per_press)


# --- Инициализация -------------------------------------------------

func generate_fog() -> void:
	var used = ground_tiles.get_used_rect()
	var tile_size = ground_tiles.tile_set.tile_size
	var world_dimensions: Vector2i = used.size * tile_size
	world_position = Vector2(used.position * tile_size)

	@warning_ignore("integer_division")
	var scaled = world_dimensions / fog_pixelation
	_fog_w = scaled.x
	_fog_h = scaled.y

	fog_image = Image.create(_fog_w, _fog_h, false, Image.Format.FORMAT_RGBA8)
	fog_image.fill(Color.BLACK)

	fog_sprite.scale = Vector2(fog_pixelation, fog_pixelation)

	vision_image = player.vision_sprite.texture.get_image()
	vision_image.convert(Image.Format.FORMAT_RGBA8)
	var vscaled = Vector2(vision_image.get_size()) / fog_pixelation
	vision_image.resize(int(vscaled.x), int(vscaled.y))

	_fog_texture = ImageTexture.create_from_image(fog_image)
	fog_sprite.texture = _fog_texture

	_frontier.clear()


func _refresh_fog_texture() -> void:
	_fog_texture.update(fog_image)
	_fog_dirty = true


# --- Хелперы -------------------------------------------------------

func _world_to_fog(world_pos: Vector2) -> Vector2i:
	return Vector2i((world_pos - world_position) / fog_pixelation)


func _in_bounds(x: int, y: int) -> bool:
	return x >= 0 and y >= 0 and x < _fog_w and y < _fog_h


func _is_territory(x: int, y: int) -> bool:
	return fog_image.get_pixel(x, y).r > erosion_threshold


func _has_fog_neighbor(x: int, y: int) -> bool:
	for d in NEIGHBORS:
		var nx = x + d.x
		var ny = y + d.y
		if not _in_bounds(nx, ny):
			return true   # край карты — как «туман»
		if fog_image.get_pixel(nx, ny).r <= erosion_threshold:
			return true
	return false


func _mark_frontier(x: int, y: int) -> void:
	if _is_territory(x, y) and _has_fog_neighbor(x, y):
		_frontier[Vector2i(x, y)] = true


func _refresh_frontier_around(p: Vector2i) -> void:
	for d in NEIGHBORS:
		var q = p + d
		if _in_bounds(q.x, q.y):
			_mark_frontier(q.x, q.y)


# --- Зрение --------------------------------------------------------

func _blend_vision() -> void:
	var vsize = vision_image.get_size()
	@warning_ignore("integer_division")
	var dst = _world_to_fog(player.global_position) - vsize / 2
	fog_image.blend_rect(vision_image, Rect2i(Vector2i.ZERO, vsize), dst)
	_update_frontier_in_rect(Rect2i(dst, vsize))


func _update_frontier_in_rect(rect: Rect2i) -> void:
	var x0: int = max(0, rect.position.x)
	var y0: int = max(0, rect.position.y)
	var x1: int = min(_fog_w, rect.position.x + rect.size.x)
	var y1: int = min(_fog_h, rect.position.y + rect.size.y)
	for y in range(y0, y1):
		for x in range(x0, x1):
			_mark_frontier(x, y)


# --- Подсчёт территории (быстро через get_data()) ------------------

func _recount_territory(force: bool = false) -> void:
	var data = fog_image.get_data()   # PackedByteArray, RGBA8
	var thresh_byte = int(erosion_threshold * 255.0)
	var explored: int = 0
	var i = 0
	var size = data.size()
	while i < size:
		if data[i] > thresh_byte:
			explored += 1
		i += 4

	var total = _fog_w * _fog_h
	var new_pct = 100.0 - float(explored) / float(total) * 100.0
	if force or absf(new_pct - territory_percent) > 0.01:
		territory_percent = new_pct
		territory_changed.emit(territory_percent)


# --- Обычная эрозия (по фронту, O(k) за шаг) ----------------------

func _erode_step() -> bool:
	if _frontier.is_empty():
		return false

	# Отбираем только пиксели, которые РЕАЛЬНО сейчас на границе.
	var to_erase: Array[Vector2i] = []
	for p: Vector2i in _frontier.keys():
		if _is_territory(p.x, p.y) and _has_fog_neighbor(p.x, p.y):
			to_erase.append(p)

	# Устаревшие записи выбрасываем.
	_frontier.clear()

	if to_erase.is_empty():
		return false

	for p in to_erase:
		var c = fog_image.get_pixel(p.x, p.y)
		fog_image.set_pixel(p.x, p.y, Color(0.0, c.g, c.b, c.a))

	for p in to_erase:
		_refresh_frontier_around(p)

	return true


# --- Секторная эрозия (тоже по фронту, с фильтром по углу) --------

func _erode_step_sector(center_angle: float, half_width: float, origin: Vector2i) -> bool:
	if _frontier.is_empty():
		return false

	var to_erase: Array[Vector2i] = []
	var stale: Array[Vector2i] = []

	for p: Vector2i in _frontier.keys():
		# Валидация: пиксель всё ещё должен быть границей
		if not (_is_territory(p.x, p.y) and _has_fog_neighbor(p.x, p.y)):
			stale.append(p)
			continue

		# Фильтр по сектору
		var dx = float(p.x - origin.x)
		var dy = float(p.y - origin.y)
		if dx == 0.0 and dy == 0.0:
			continue
		var diff = wrapf(atan2(dy, dx) - center_angle, -PI, PI)
		if absf(diff) <= half_width:
			to_erase.append(p)

	for p in stale:
		_frontier.erase(p)
	for p in to_erase:
		_frontier.erase(p)

	if to_erase.is_empty():
		return false

	for p in to_erase:
		var c = fog_image.get_pixel(p.x, p.y)
		fog_image.set_pixel(p.x, p.y, Color(0.0, c.g, c.b, c.a))

	for p in to_erase:
		_refresh_frontier_around(p)

	return true


# --- Сонар ---------------------------------------------------------

func _sweep_from_to(from_angle: float, to_angle: float) -> bool:
	if to_angle <= from_angle:
		return false

	# ВАЖНО: центр держим ДРОБНЫМ.
	# Если округлить до int — на осях E/N/S/W ровно один пиксель
	# окажется на расстоянии ровно r и вылезет «шипом», ломая круг.
	var center = (player.global_position - world_position) / float(fog_pixelation)

	var radius_px: float = sweep_beam_radius_world / float(fog_pixelation)

	var min_x: int = max(0, int(floor(center.x - radius_px)))
	var max_x: int = min(_fog_w - 1, int(ceil(center.x + radius_px)))
	var min_y: int = max(0, int(floor(center.y - radius_px)))
	var max_y: int = min(_fog_h - 1, int(ceil(center.y + radius_px)))

	var r2: float = radius_px * radius_px
	var revealed = false

	for y in range(min_y, max_y + 1):
		var dy = float(y) - center.y
		for x in range(min_x, max_x + 1):
			var dx = float(x) - center.x
			if dx * dx + dy * dy > r2:
				continue

			var a = atan2(dy, dx)
			if a < 0.0:
				a += TAU
			if a < from_angle or a > to_angle:
				continue

			var existing = fog_image.get_pixel(x, y)
			if existing.r < 1.0:
				fog_image.set_pixel(x, y, Color(1.0, existing.g, existing.b, existing.a))
				_mark_frontier(x, y)
				revealed = true

	return revealed

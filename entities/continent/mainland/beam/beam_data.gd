class_name BeamData
extends RefCounted


signal shelters_changed

var mainland: MainlandData
var current_shelter: ShelterData
var next_shelter: ShelterData:
	set(value_):
		next_shelter = value_
		shelters_changed.emit()


func _init(mainland_: MainlandData) -> void:
	mainland = mainland_

func get_anchor() -> Vector2:
	var anchor: Vector2
	if current_shelter == null or next_shelter == null: return anchor
	anchor = (current_shelter.center + next_shelter.center) / 2
	return anchor

func get_angle() -> float:
	var angle: float
	if current_shelter == null or next_shelter == null: return angle
	angle = -PI / 2 + (next_shelter.center - current_shelter.center).angle()
	return rad_to_deg(angle)

func update_shelters() -> void:
	var spotlight = Mother.guild.scout.current_spotlight
	var options = Mother.guild.scout.internals.filter(func (a): return a.neighbor_shelters.has(spotlight.shelter))
	current_shelter = options.front()
	next_shelter = spotlight.shelter

func activate() -> void:
	if current_shelter == null or next_shelter == null: return
	mainland.haze.reveal_shelter_then_neighbors_wave(next_shelter.index)
	next_shelter = null

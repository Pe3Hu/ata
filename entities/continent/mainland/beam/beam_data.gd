class_name BeamData
extends RefCounted


signal shelters_changed

var mainland: MainlandData
var first_shelter: ShelterData
var second_shelter: ShelterData:
	set(value_):
		second_shelter = value_
		shelters_changed.emit()



func _init(mainland_: MainlandData) -> void:
	mainland = mainland_

func get_anchor() -> Vector2:
	var anchor: Vector2
	if first_shelter == null or second_shelter == null: return anchor
	anchor = (first_shelter.center + second_shelter.center) / 2
	return anchor

func get_angle() -> float:
	var angle: float
	if first_shelter == null or second_shelter == null: return angle
	angle = -PI / 2 + (second_shelter.center - first_shelter.center).angle()
	return rad_to_deg(angle)

func activate() -> void:
	if first_shelter == null or second_shelter == null: return
	mainland.haze.reveal_shelter_then_neighbors_wave(second_shelter.index)
	second_shelter = null

class_name AsterismData
extends RefCounted


var welkin: WelkinData
var external_star: StarData
var internal_star: StarData


func _init(welkin_: WelkinData, external_volume_: int) -> void:
	welkin = welkin_
	
	external_star = StarData.new(external_volume_)
	external_star.asterism = self
	internal_star = StarData.new(Digest.external_to_internal[external_volume_])
	internal_star.asterism = self
	
	reset()
	
	welkin.asterisms.append(self)
	welkin.volume_to_asterism[external_star.volume] = self
	welkin.volume_to_asterism[external_star.volume] = self

func reset() -> void:
	external_star.current = 0
	internal_star.current = 0

func full_fill() -> void:
	external_star.current = internal_star.current
	internal_star.current = internal_star.limit

class_name AsterismData
extends RefCounted


var welkin: WelkinData
var main_star: StarData
var secondary_star: StarData


func _init(welkin_: WelkinData, main_volume_: int) -> void:
	welkin = welkin_
	
	main_star = StarData.new(main_volume_)
	main_star.asterism = self
	secondary_star = StarData.new(Digest.main_to_secondary[main_volume_])
	secondary_star.asterism = self
	
	reset()
	
	welkin.asterisms.append(self)
	welkin.volume_to_asterism[main_star.volume] = self
	welkin.volume_to_asterism[main_star.volume] = self

func reset() -> void:
	main_star.current = 0
	secondary_star.current = 0

func full_fill() -> void:
	main_star.current = secondary_star.current
	secondary_star.current = secondary_star.limit

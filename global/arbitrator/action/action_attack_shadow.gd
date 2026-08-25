class_name ActionAttackShadow
extends ActionData


var shadow: ShadowData
var room: Room


func _init(shadow_: ShadowData, room_: Room = null) -> void:
	type = Bozo.Action.ATTACK_SHADOW
	shadow = shadow_
	room = room_

func execute() -> void:
	var canto = shadow.stamp.origin.atheneum.faction.odeum.current_canto
	if not canto: return
	canto.apply_voice()
	
	if canto:
		var damage = shadow.current_shade - canto.pulse_value
		
		if damage > 0:
			shadow.current_shade -= canto.pulse_value
		else:
			shadow.current_shade = 0
		
		if damage == 0:
			print("CRITICAL DAMAGE")
		
		if shadow.current_shade == 0:
			if room:
				var card = room.stamp_to_card[shadow.stamp]
				card.flip_on_stamp()

class_name ActionAttackShadow
extends ActionData


var shadow: ShadowData
var is_advisor: bool


func _init(shadow_: ShadowData, is_advisor_: bool = false) -> void:
	shadow = shadow_
	is_advisor = is_advisor_
	type = Bozo.Action.ATTACK_SHADOW

func execute() -> void:
	var canto = shadow.stamp.origin.atheneum.faction.odeum.current_canto
	if not canto: return
	canto.apply_voice()
	shadow.action = self
	
	if canto:
		var damage = shadow.current_shade - canto.pulse_value
		
		if damage > 0:
			shadow.current_shade -= canto.pulse_value
		else:
			shadow.current_shade = 0
		
		if damage == 0:
			print("CRITICAL DAMAGE")

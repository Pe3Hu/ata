class_name ActionAttackShadow
extends ActionData


var shadow: ShadowData

var is_advisor: bool
var is_perfect: bool = false



func _init(shadow_: ShadowData, is_advisor_: bool = false) -> void:
	shadow = shadow_
	is_advisor = is_advisor_
	type = Bozo.Action.ATTACK_SHADOW
	animation_left = 2

func execute() -> void:
	var canto = shadow.stamp.origin.atheneum.faction.odeum.current_canto
	if not canto: return
	super.execute()
	canto.apply_voice()
	shadow.action = self
	
	if canto:
		var damage = shadow.current_shade - canto.pulse_value
		
		if damage == 0:
			is_perfect = true
			print("PERFECT ATTACK")
		
		if damage > 0:
			shadow.current_shade -= canto.pulse_value
			animation_left = 0
		else:
			shadow.current_shade = 0

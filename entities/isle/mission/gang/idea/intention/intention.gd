class_name Intention
extends PanelContainer


var data: IntentionData:
	set(value_):
		data = value_
		
		calc_anchor_angle()
		modulate = Digest.element_to_color[data.element]
		var path = Bozo.enum_to_string(Bozo.Type.ASPECT, data.aspect)
		%Body.texture = load('res://entities/isle/mission/gang/idea/intention/images/body/%s.png' % path)
		%Border.texture = load('res://entities/isle/mission/gang/idea/intention/images/border/%s.png' % path)

var idea: Idea
var anchor_angle: float


func calc_anchor_angle() -> void:
	anchor_angle = TAU / Catalog.IDEA_INTENTION_AMOUNT * get_index() + PI / 2
	offset_transform_position = Vector2.from_angle(anchor_angle + idea.anchor_angle) * Catalog.INENTION_OFFSET

#func _process(delta_: float) -> void:
	#anchor_angle = wrapf(
		#lerp_angle(anchor_angle, anchor_angle + delta_ * Catalog.IDEA_ROTATION_SPEED, delta_ * Catalog.IDEA_ROTATION_SPEED),
		#0.0, TAU
	#)
	#offset_transform_position = Vector2.from_angle(anchor_angle) * Catalog.INENTION_OFFSET

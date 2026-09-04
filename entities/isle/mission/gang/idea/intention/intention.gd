class_name Intention
extends PanelContainer


var data: IntentionData:
	set(value_):
		data = value_
		
		connect_signals()
		update_textures()
		calc_anchor_angle()

var idea: Idea
var anchor_angle: float
var bond_angle: float:
	set(value_):
		bond_angle = value_
		offset_transform_position = Vector2.from_angle(bond_angle + anchor_angle + idea.anchor_angle) * Catalog.INENTION_OFFSET


func connect_signals() -> void:
	data.bond_changed.connect(_on_bond_changed)

func _on_bond_changed() -> void:
	%Body.visible = not data.is_bond

func update_textures() -> void:
	modulate = Digest.element_to_color[data.element]
	var path = Bozo.enum_to_string(Bozo.Type.ASPECT, data.aspect)
	%Body.texture = load('res://entities/isle/mission/gang/idea/intention/images/body/%s.png' % path)
	%Border.texture = load('res://entities/isle/mission/gang/idea/intention/images/border/%s.png' % path)

func calc_anchor_angle() -> void:
	if not idea: return
	anchor_angle = TAU / Catalog.IDEA_INTENTION_AMOUNT * get_index() + PI / 2
	bond_angle = 0

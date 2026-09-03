class_name Idea
extends PanelContainer


var intention_scene = preload('uid://bhtnr3epno3wi')

var data: IdeaData:
	set(value_):
		data = value_
		
		connect_signals()
		calc_anchor()
		init_intentions()
		init_lines()

var anchor_angle: float
var bond_angle: float

var bond_tween: Tween


#region init
func connect_signals() -> void:
	data.active_changed.connect(_on_active_changed)
	data.bond_changed.connect(_on_bond_changed)

func _on_active_changed() -> void:
	%Lines.visible = data.is_active
	
	if data.is_active:
		%CustomButton.self_modulate.a = 0.0
	else:
		%CustomButton.self_modulate.a = 1.0

func _on_bond_changed() -> void:
	if bond_tween and bond_tween.is_running():
		bond_tween.kill()
	
	bond_angle = -data.bond_index * TAU / data.intentions.size()
	var duration = Gear.bonds[Gear.tempo]
	bond_tween = create_tween().set_parallel(true)
	
	var current_button = %CustomButton.offset_transform_rotation
	var desired_button = bond_angle + anchor_angle
	var delta_button = wrapf(desired_button - current_button, -PI, PI)
	bond_tween.tween_property(%CustomButton, 'offset_transform_rotation', current_button + delta_button, duration)
	
	var current_lines = %Lines.rotation
	var desired_lines = bond_angle
	var delta_lines = wrapf(desired_lines - current_lines, -PI, PI)
	bond_tween.tween_property(%Lines, 'rotation', current_lines + delta_lines, duration)
	
	for intention in %Intentions.get_children():
		var current_total = intention.bond_angle + intention.anchor_angle + intention.idea.anchor_angle
		var desired_total = bond_angle + intention.anchor_angle + intention.idea.anchor_angle
		var delta = wrapf(desired_total - current_total, -PI, PI)
		var target_bond = intention.bond_angle + delta
		bond_tween.tween_property(intention, 'bond_angle', target_bond, duration)
	
	await bond_tween.finished
	
	if data.is_active:
		var bond_intention = data.intentions[data.bond_index]
		bond_intention.is_bond = true

func calc_anchor() -> void:
	%CustomButton.hover_scale = Vector2(1.05, 1.05)
	%CustomButton.pressed_scale = Vector2(0.95, 0.95)
	#%CustomButton.position = -%CustomButton.size / 2
	%Intentions.offset_transform_position = -Catalog.INENTION_SIZE / 2
	%Lines.position = size / 2 
	
	var n = data.gang.ideas.size()
	if n == 1: return
	
	anchor_angle = TAU / n * get_index() 
	var r = Helper.get_idea_radius(n)
	position = Vector2.from_angle(anchor_angle - PI / 2) * r
	
	%CustomButton.offset_transform_rotation = anchor_angle

func init_intentions() -> void:
	for intention_data in data.intentions:
		add_intention(intention_data)

func add_intention(intention_data: IntentionData) -> void:
	var intention = intention_scene.instantiate()
	%Intentions.add_child(intention)
	intention.idea = self
	intention.data = intention_data

func init_lines() -> void:
	var n = %Intentions.get_child_count()
	var _i = 0
	
	for _k in n:
		var a = %Intentions.get_child(_i)
		var _j = (_i + 2) % n
		
		var b = %Intentions.get_child(_j)
		add_line(a, b)
		_i += 1

func add_line(a_: Intention, b_: Intention) -> void:
	var line = Line2D.new()
	line.z_index = data.intentions.size() - %Lines.get_child_count()

	%Lines.add_child(line)
	
	line.add_point(a_.offset_transform_position)
	line.add_point(b_.offset_transform_position)
	
	var grad = Gradient.new()
	grad.set_color(0, a_.modulate)
	grad.set_color(1, b_.modulate)   
	line.gradient = grad
#endregion

func _on_custom_button_pressed() -> void:
	data.gang.attempt.first_idea = data

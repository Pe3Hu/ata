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
var bound_angle: float


func connect_signals() -> void:
	data.active_changed.connect(_on_active_changed)

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

func _on_custom_button_pressed() -> void:
	data.gang.first_idea = data
	#data.is_active = !data.is_active
	#_on_active_changed()

func _on_active_changed() -> void:
	%Lines.visible = data.is_active
	
	if data.is_active:
		%CustomButton.self_modulate.a = 0.0
	else:
		%CustomButton.self_modulate.a = 1.0

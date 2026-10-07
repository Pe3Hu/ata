class_name Method
extends PanelContainer


var data: MethodData:
	set(value_):
		data = value_
		
		connect_signals()
		update_intentions()
		update_offsets()
		%Title.text = Bozo.enum_to_string(Bozo.Type.METHOD, data.type).capitalize()


#region init
func connect_signals() -> void:
	data.difficulty_changed.connect(_on_difficulty_changed)
	_on_difficulty_changed()
	data.impulse.value_changed.connect(_on_impulse_changed)
	_on_impulse_changed()

func update_offsets() -> void:
	var rnd_offset = Helper.rng.randf_range(0, 2.5)
	%DifficultyPerfect.material.set_shader_parameter('async_origin_offset', rnd_offset)
	rnd_offset = Helper.rng.randf_range(2.5, 5)
	%ImpulsePerfect.material.set_shader_parameter('async_origin_offset', rnd_offset)
	var color = Digest.element_to_color[Digest.method_to_element[data.type]]
	%ImpulseBody.material.set_shader_parameter('base_color', color)
	color.s -= 0.4
	%ImpulsePerfect.material.set_shader_parameter('wave_color', color)
	%DifficultyPerfect.material.set_shader_parameter('wave_color', color)

func _on_difficulty_changed() -> void:
	%Difficulty.text = str(max(data.current_difficulty, 0))
	upadate_perfects()

func _on_impulse_changed() -> void:
	%Impulse.text = str(data.impulse.value)
	upadate_perfects()

func upadate_perfects() -> void:
	%DifficultyPerfect.visible = data.current_difficulty == data.impulse.value and data.current_difficulty > 0
	%ImpulsePerfect.visible = data.current_difficulty == data.impulse.value and data.current_difficulty > 0

func update_intentions() -> void:
	var main_intention = IntentionData.new()
	main_intention.aspect = Digest.method_to_factor_to_aspect[data.type][2]
	main_intention.element = Digest.method_to_element[data.type]
	%Intention1.data = main_intention
	%Intention2.data = main_intention
	
	var secondary_intention = IntentionData.new()
	secondary_intention.aspect = Digest.method_to_factor_to_aspect[data.type][1]
	secondary_intention.element = Digest.method_to_element[data.type]
	%Intention3.data = secondary_intention
#endregion

func _on_body_pressed() -> void:
	if Mother.cottage.kitchen.ideas.size() < 2:
		Mother.kernel.maelstrom.focused_eddy.afterburner()
		return
	
	var attempt = data.obstacle.ruin.bank.depredation.gang.attempt
	if attempt and attempt.second_idea:
		data.execute()
	
	if Mother.cottage.kitchen.ideas.size() < 2:
		Mother.kernel.maelstrom.focus_on_element(Digest.method_to_element[data.type])

func _on_impulse_body_mouse_entered() -> void:
	if Mother.cottage.kitchen.ideas.size() < 2:
		Mother.kernel.maelstrom.focus_on_element(Digest.method_to_element[data.type])

func _on_impulse_body_mouse_exited() -> void:
	if Mother.cottage.kitchen.ideas.size() < 2:
		Mother.kernel.maelstrom.focus_on_element()

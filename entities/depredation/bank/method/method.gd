class_name Method
extends PanelContainer


var data: MethodData:
	set(value_):
		data = value_
		
		connect_signals()
		update_intentions()
		update_colors()
		%Title.text = Bozo.enum_to_string(Bozo.Type.METHOD, data.type).capitalize()


#region init
func connect_signals() -> void:
	data.difficulty_changed.connect(_on_difficulty_changed)
	_on_difficulty_changed()
	data.impulse.value_changed.connect(_on_impulse_changed)
	_on_impulse_changed()

func update_colors() -> void:
	var color = Digest.element_to_color[Digest.method_to_element[data.type]]
	%ImpulseBody.material.set_shader_parameter('base_color', color)
	%DifficultyBody.material.set_shader_parameter('base_color', color)
	%ActionButton.material.set_shader_parameter('base_color', color)
	%PerfectTrail.material.set_shader_parameter('hue', Digest.element_to_hue[Digest.method_to_element[data.type]])
	#color.s -= 0.4

func _on_difficulty_changed() -> void:
	%Difficulty.text = str(max(data.current_difficulty, 0))
	upadate_perfects()

func _on_impulse_changed() -> void:
	%Impulse.text = str(data.impulse.value)
	upadate_perfects()

func upadate_perfects() -> void:
	%PerfectTrail.visible = data.current_difficulty == data.impulse.value and data.current_difficulty > 0
	#%PerfectTrail.visible = data.current_difficulty < 15 and data.impulse.value < 15 and data.impulse.value > 0
	%ImpulseBorder.visible = not %PerfectTrail.visible
	%ImpulseBody.visible = not %PerfectTrail.visible

func update_intentions() -> void:
	%Intention1.data = data.intentions.front()
	%Intention2.data = data.intentions.back()
#endregion


func _on_action_button_pressed() -> void:
	if Mother.cottage.kitchen.ideas.size() < 2:
		Mother.kernel.maelstrom.focused_eddy.afterburner()
		return
	
	var attempt = data.obstacle.ruin.bank.depredation.gang.attempt
	if attempt and attempt.second_idea:
		data.execute()
	
	if Mother.cottage.kitchen.ideas.size() < 2:
		Mother.kernel.maelstrom.focus_on_element(Digest.method_to_element[data.type])


func _on_action_button_mouse_entered() -> void:
	if Mother.cottage.kitchen.ideas.size() < 2:
		Mother.kernel.maelstrom.focus_on_element(Digest.method_to_element[data.type])

func _on_action_button_mouse_exited() -> void:
	if Mother.cottage.kitchen.ideas.size() < 2:
		Mother.kernel.maelstrom.focus_on_element()

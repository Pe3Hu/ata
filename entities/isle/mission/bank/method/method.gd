class_name Method
extends PanelContainer


var data: MethodData:
	set(value_):
		data = value_
		
		connect_signals()
		update_intentions()
		%Title.text = Bozo.enum_to_string(Bozo.Type.METHOD, data.type)


func connect_signals() -> void:
	data.difficulty_changed.connect(_on_difficulty_changed)
	_on_difficulty_changed()
	data.impulse.value_changed.connect(_on_impulse_changed)
	_on_impulse_changed()

func _on_difficulty_changed() -> void:
	%Difficulty.text = str(data.difficulty)

func _on_impulse_changed() -> void:
	%Impulse.text = str(data.impulse.value)

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

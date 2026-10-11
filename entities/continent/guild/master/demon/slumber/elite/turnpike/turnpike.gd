class_name Turnpike
extends PanelContainer


@export var slumber: Slumber


func update() -> void:
	#if not Digest.element_to_addend.has(slumber.data.rift.gloom.element): return
	if not Catalog.turnpike_elements.has(slumber.data.rift.gloom.element): return
	visible = true
	update_razors()
	connect_datas()
	update_comparison()

func connect_datas() -> void:
	if not slumber.data.turnpike_changed.is_connected(_on_turnpike_chaned):
		slumber.data.turnpike_changed.connect(_on_turnpike_chaned)
	
	_on_turnpike_chaned()

func _on_turnpike_chaned() -> void:
	%LimitRein.data.volume = slumber.data.current_turnpike
	%LimitRein.visible = %LimitRein.data.volume > 0

func update_razors() -> void:
	var element = slumber.data.rift.gloom.element
	var matters = []
	var volume = 0
	
	if Digest.element_to_addend.has(element):
		volume = Digest.element_to_addend[element]
	
	%LimitRein.data = ReinData.new(volume, matters, element)
	#%LimitRein.visible = volume > 0

func update_comparison() -> void:
	var element = slumber.data.rift.gloom.element
	var comparison = Digest.element_to_comparison[element]
	#if Catalog.mirror_elements.has(element):
		#comparison = Digest.comparison_to_mirror[comparison]
	var str_type = Bozo.enum_to_string(Bozo.Type.COMPARISON, comparison)
	%ComparisonBody.texture = load('res://entities/continent/guild/master/demon/slumber/elite/images/%s/body.png' % str_type)
	%ComparisonBorder.texture = load('res://entities/continent/guild/master/demon/slumber/elite/images/%s/border.png' % str_type)
	%ComparisonBody.material.set_shader_parameter('base_color', Digest.element_to_color[element])
	
	var element_fixed = Digest.element_to_addend.has(element)
	var choices = slumber.data.get_turnpike_choices()
	var can_shift = not element_fixed and choices.size() > 1
	
	%PreviousButton.visible = can_shift
	%PreviousButton2.visible = can_shift
	offset_transform_position.y = Catalog.TURNPIKE_OFFSET if can_shift else 0

func _on_previous_button_pressed() -> void:
	slumber.data.changed_turnpike(1)

func _on_next_button_pressed() -> void:
	slumber.data.changed_turnpike(-1)

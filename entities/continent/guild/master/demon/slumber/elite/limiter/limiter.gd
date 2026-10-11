class_name Limiter
extends PanelContainer


@export var elite: Elite
@export var tune: Bozo.Tune


func update() -> void:
	visible = true
	update_razors()
	update_comparison()
	
	if Digest.element_to_sum.has(elite.gloom.data.element):
		for member in elite.slumber.data.agent.squad.members:
			member.preview_soul_changed.connect(_on_squad_changed)
		
		_on_squad_changed()

func _on_squad_changed() -> void:
	var sum_value := 0
	
	for _i in elite.slumber.data.agent.squad.members.size():
		var soul = elite.slumber.data.agent.squad.members[_i].preview_soul
		if soul == null: continue
		var dice = soul.get(Bozo.enum_to_string(Bozo.Type.TUNE, tune))
		sum_value += dice.get_sum()
	
	%CurrentRein.data.volume = sum_value
	#%CurrentRein.update_label()

func update_razors() -> void:
	var element = elite.gloom.data.element
	if not Digest.element_to_sum.has(element): return
	var volume = Digest.element_to_sum[element]
	var matters = []
	var suffix = Digest.tune_to_suffix[tune]
	%LimitRein.data = ReinData.new(volume, matters, element, suffix)
	volume = 0
	%CurrentRein.data = ReinData.new(volume, matters, element, suffix)

func update_comparison() -> void:
	var element = elite.gloom.data.element
	var comparison = Digest.element_to_comparison[element]
	var str_type = Bozo.enum_to_string(Bozo.Type.COMPARISON, comparison)
	%ComparisonBody.texture = load('res://entities/continent/guild/master/demon/slumber/elite/images/%s/body.png' % str_type)
	%ComparisonBorder.texture = load('res://entities/continent/guild/master/demon/slumber/elite/images/%s/border.png' % str_type)
	%ComparisonBody.material.set_shader_parameter('base_color', Digest.element_to_color[element])

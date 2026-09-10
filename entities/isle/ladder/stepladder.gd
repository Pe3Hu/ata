class_name Stepladder
extends Node2D


const stair_scene = preload("uid://dhgdl75u1j75h")
const girder_scene = preload("uid://b8imnf6o57n7v")
const dice_scene = preload('uid://t1702e0u2fqx')


var data: StepladderData:
	set(value_):
		data = value_
		
		connect_signals()
		init_stairs()
		init_girders()

var current_stair: Stair
var volume_to_stair: Dictionary


#region init
func _ready() -> void:
	position = get_parent().size / 2
	position -= Vector2(Catalog.LADDER_GRID) * Catalog.STAIR_SIZE / 2 
	position += Catalog.STEPLADDER_OFFSET
	
	%DiceContainer.offset_transform_position = Vector2(-Catalog.STAIR_SIZE.x / 3, Catalog.STEPLADDER_SIZE.y)

func connect_signals() -> void:
	data.volume_changed.connect(_on_volume_changed)
	_on_volume_changed()
	data.pressure_changed.connect(_on_pressure_changed)
	_on_pressure_changed()

func _on_volume_changed() -> void:
	visible = data.flux != null
	
	if current_stair:
		current_stair.is_current = false
	
	if data.flux:
		current_stair = volume_to_stair[data.flux.volume]
		current_stair.is_current = true

func _on_pressure_changed() -> void:
	visible = data.pressure != null
	if data.pressure == null: return
	
	var n = data.pressure.amount
	var element = Arbitrator.last_action.shadow.pressure.element
	data.flux = data.kernel.maelstrom.element_to_eddy[element].flux
	
	if Arbitrator.last_action and Arbitrator.last_action.type == Bozo.Action.ATTACK_SHADOW and Arbitrator.last_action.is_perfect:
		n += 1
	
	for _i in n:
		add_dice()
	
	apply_pressure()

func add_dice() -> void:
	var dice = dice_scene.instantiate()
	%Dices.add_child(dice)
	var matter = Digest.elememt_to_in[data.pressure.element]
	dice.data = load('res://entities/dice/datas/pressure/%s.tres' % Bozo.enum_to_string(Bozo.Type.MATTER, matter))
	var color = Digest.element_to_color[data.pressure.element]#Digest.matter_to_color[matter]
	dice.update_color(color)

func init_stairs() -> void:
	for stair_data in Helper.ladder.stairs:
		add_stair(stair_data)

func add_stair(stair_data_: StairData) -> void:
	var stair = stair_scene.instantiate()
	%Stairs.add_child(stair)
	stair.data = stair_data_
	volume_to_stair[stair_data_.volume] = stair

func init_girders() -> void:
	for girder_data in Helper.ladder.girders:
		add_girder(girder_data)

func add_girder(girder_data_: GirderData) -> void:
	var girder = girder_scene.instantiate()
	%Girders.add_child(girder)
	girder.data = girder_data_

#endregion

func apply_pressure() -> void:
	for dice in %Dices.get_children():
		dice.visible = true
		dice.start_roll()
		Arbitrator.queue_an_animation(dice.digit_tween)
		dice.digit_tween.finished.connect(_on_punishment_roll_end.bind(dice))

func _on_punishment_roll_end(_dice: FakeDice) -> void:
	if Arbitrator.current_phase.animation_tweens.is_empty():
		choose_dice()

func choose_dice() -> void:
	var pressure_dice: FakeDice
	#var options = %Dices.get_children()
	var useful_matters = Digest.volume_to_matter_to_volume[data.flux.volume].keys()
	var useful_volumes = []
	var useful_dices = []
	
	for matter in useful_matters:
		var volume = Digest.matter_to_factor[matter]
		useful_volumes.append(volume)
	
	useful_volumes.sort()
	
	for dice in %Dices.get_children():
		if useful_volumes.has(dice.get_current_value()):
			useful_dices.append(dice)
	
	if not useful_dices.is_empty():
		useful_dices.sort_custom(func (a, b): return useful_volumes.find(a.get_current_value()) < useful_volumes.find(b.get_current_value()))
		pressure_dice = useful_dices.front()
		#options.erase(pressure_dice)
		pressure_dice.start_pressure_animation(self)
	else:
		dissolve_dices()


func dissolve_dices() -> void:
	for dice in %Dices.get_children():
		dice.start_dissolve_animation()

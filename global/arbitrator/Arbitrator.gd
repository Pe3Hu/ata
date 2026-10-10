extends Node


signal phase_changed(phase: Bozo.Phase)

var is_gameover: bool = true
var current_round: int = 0

var phases: Array[Phase]
var current_phase_index: int = 0
var current_phase: Phase

var last_action: ActionData:
	set(value_):
		last_action = value_
		
		if Gear.is_auto_play and last_action == null:
			var choice = Advisor.get_choice()
			if choice and choice.has_method("next_action"):
				choice.next_action()


func _ready() -> void:
	phases = [
		PhaseDraw.new(),
		PhaseDecision.new(),
		PhaseDiscard.new(),
		PhaseFusion.new(),
		PhasePunishment.new(),
	]

#region round
func start_new_round() -> void:
	current_round += 1
	current_phase_index = 0
	print("### ROUND %d ###" % [current_round])
	start_next_phase()
#endregion

#region phase
func start_next_phase() -> void:
	if Gear.is_pause: return
	if is_gameover: return
	current_phase = phases[current_phase_index]
	current_phase.phase_completed.connect(_on_phase_completed, CONNECT_ONE_SHOT)
	phase_changed.emit(current_phase.type)
	current_phase.enter_phase()

func _on_phase_completed() -> void:
	current_phase = null
	current_phase_index += 1
	
	if current_phase_index == phases.size():
		start_new_round()
	else:
		start_next_phase()
#endregion

func queue_an_animation(tween_: Tween) -> void:
	if not current_phase: return
	if current_phase.animation_tweens.has(tween_): return
	current_phase.animation_tweens.append(tween_)
	tween_.finished.connect(current_phase._on_tween_finished.bind(tween_, current_phase.animation_epoch))

func skip_phase() -> void:
	if current_phase:
		current_phase.exit_phase()

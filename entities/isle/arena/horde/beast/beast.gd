class_name Beast
extends CharacterBody2D



var data: BeastData:
	set(value_):
		data = value_
		
		connect_signals()

var health_tween: Tween


func connect_signals() -> void:
	data.collar.health_changed.connect(_on_health_changed)
	%HealthLabel.text = str(data.collar.health_current)

func _on_health_changed() -> void:
	if health_tween and health_tween.is_running():
		health_tween.kill()
	
	if data.collar.health_current == 0:
		_check_death()
		return
	
	var duration = 1.0
	
	health_tween = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_SINE)
	health_tween.tween_property(%HealthLabel, "text", str(data.collar.health_current), duration)
	health_tween.tween_callback(_check_death)

func _check_death() -> void:
	if data.collar.health_current > 0: return
	data.die()
	get_parent().remove_child(self)
	queue_free()

func update_animation() -> void:
	if velocity.length() == 0:
		if %AnimationPlayer.is_playing():
			%AnimationPlayer.stop()
	else:
		var angle = velocity.angle()
		
		if angle < 0:
			angle += PI * 2
		
		var direction = "Right"
		
		if angle >= PI/4 and angle < PI*3/4:
			direction = "Down"
		elif angle >= PI*3/4 and angle < PI*5/4:
			direction = "Left"
		elif angle >= PI*5/4 and angle < PI*7/4:
			direction = "Up"
		
		%AnimationPlayer.play("walk" + direction)


func _physics_process(_delta: float) -> void:
	if data.is_moving:
		move_towards_target(_delta)
	
	move_and_slide()
	update_animation()

func move_towards_target(_delta: float) -> void:
	var current_position = global_position
	var distance = current_position.distance_to(data.target_position)
	
	if distance > 5.0:
		velocity = current_position.direction_to(data.target_position) * data.speed
	else:
		velocity = Vector2.ZERO
		data.is_moving = false

func move_to(target_: Vector2) -> void:
	data.target_position = target_
	data.is_moving = true

func _input(event) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			move_to(get_global_mouse_position())

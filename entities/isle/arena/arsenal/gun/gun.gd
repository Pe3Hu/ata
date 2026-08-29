class_name Gun
extends Node2D


var bullet_scene = preload("uid://njw7gblmc085")

@export var arsenal: Arsenal

var tempo: float = 0.25
var can_shoot: bool = true


func _ready() -> void:
	%ShootTimer.wait_time = tempo
	#%Shadow.position = Vector2(-2, 2).rotated(-%Body.rotation)

#func _physics_process(delta_: float) -> void:
	#var new_angle = (get_global_mouse_position() - global_position).angle()
	#%Body.rotation = lerp_angle(%Body.rotation, new_angle, 6.5 * delta_)
	#%Shadow.position = Vector2(-2, 2).rotated(-%Body.rotation)

func shoot() -> void:
	if not can_shoot: return
	add_bullet()
	can_shoot = false
	%ShootTimer.start()

func add_bullet() -> void:
	var bullet = bullet_scene.instantiate()
	bullet.global_position = %Barrel.global_position
	bullet.global_rotation = %Barrel.global_rotation
	get_tree().root.add_child(bullet)

func _input(event) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			shoot()
			
	if event is InputEventKey and event.is_pressed() and not event.is_echo():
		match event.keycode:
			KEY_SPACE:       
				pass

func _on_shoot_timer_timeout() -> void:
	can_shoot = true

class_name Bullet
extends Sprite2D


var speed: float = 120.0


func _ready() -> void:
	%AnimationPlayer.play("appear")

func _physics_process(delta_: float) -> void:
	global_position += Vector2(1, 0).rotated(rotation) * speed * delta_
	%Shadow.position = Vector2(-2, 2).rotated(-rotation)
	
	if %RayCast.is_colliding():
		var collider = %RayCast.get_collider()
		%RayCast.enabled = false
		
		if collider.is_in_group("beast"):
			collider.data.collar.take_damage()
		
		%AnimationPlayer.play("disappear")
		

func _on_distance_timer_timeout() -> void:
	%AnimationPlayer.play("disappear")

func _on_animation_player_animation_finished(anim_name_: StringName) -> void:
	match anim_name_:
		"disappear":
			get_parent().remove_child(self)
			queue_free()

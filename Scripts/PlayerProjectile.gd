extends Area2D

export var damage : int = 10;
export var speed : int = 1000;

var dir = Vector2();

func _physics_process(delta):
	# move forward at the specified speed
	global_position += dir * speed * delta

# Apply damage to the enemy if collided with it

func _on_Projectile_area_entered(area):
	if area.is_in_group("EnemyHurtBox"):
		area.get_parent().take_damage(damage + 2, damage - 2, dir)
		$AudioStreamPlayer2D.play()
		queue_free()

# destroy the instance if it gets out of the screen.

func _on_VisibilityNotifier2D_screen_exited():
	queue_free()

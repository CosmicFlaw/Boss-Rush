extends Area2D

const ROTATION_SPEED = 100

export var damage : int = 5;
export var speed : int = 1000;

var dir = Vector2();
var queue : Array;


func _physics_process(delta):
	# move forward at the specified speed
	$Sprite.rotation += ROTATION_SPEED;
	if dir != Vector2.ZERO:
		global_position += dir * speed * delta
	else:
		queue_free();


# Apply damage to the enemy if collided with it

func _on_Projectile_area_entered(area):
	if area.is_in_group("EnemyHurtBox"):
		area.get_parent().take_damage(damage + 2, damage - 2, dir);
		queue_free();
	elif area.is_in_group("BossHitBox"):
		area.get_parent().get_parent()._take_damage(damage + 2, damage - 2);
		queue_free();



# destroy the instance if it gets out of the screen.

func _on_VisibilityNotifier2D_screen_exited():
	queue_free();


func _on_Projectile_body_entered(body):
	if not body.is_in_group("Player"):
		queue_free();

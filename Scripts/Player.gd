extends KinematicBody2D

const Squash_time : float = 0.4;

var velocity : Vector2

export var max_speed : int = 600
export var gravity : float = 55
export var jump_force : int = 1200
export var acceleration : int = 25
export var jump_buffer_time : int  = 10
export var cayote_time : int = 7
export var friction: float = .3

var jump_buffer_counter : int = 0
var cayote_counter : int = 0

func _physics_process(_delta):
	
	if is_on_floor():
		cayote_counter = cayote_time

	if not is_on_floor():
		if cayote_counter > 0:
			cayote_counter -= 1
		
		velocity.y += gravity
		if velocity.y > 4000:
			velocity.y = 4000

	if Input.is_action_pressed("ui_right"):
		if velocity.x >= 0:
			velocity.x += acceleration
		else:
			velocity.x += acceleration - velocity.x/3;
		$Sprite.flip_h = false

	elif Input.is_action_pressed("ui_left"):
		if velocity.x <= 0:
			velocity.x -= acceleration
		else:
			velocity.x -= acceleration + velocity.x/3;
		$Sprite.flip_h = true

	else:
			velocity.x = lerp(velocity.x,0, friction)
	
	velocity.x = clamp(velocity.x, -max_speed, max_speed)
	
	if Input.is_action_just_pressed("Jump"):
		jump_buffer_counter = jump_buffer_time
	
	if jump_buffer_counter > 0:
		jump_buffer_counter -= 1
	
	if jump_buffer_counter > 0 and cayote_counter > 0:
		var tween = $Tween;
		tween.interpolate_property($Sprite, "scale", Vector2(1.0, 1.0), Vector2(.5, 1.5), Squash_time, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT);
		tween.start();
		velocity.y = -jump_force;
		jump_buffer_counter = 0;
		cayote_counter = 0;
		tween.interpolate_property($Sprite, "scale", Vector2(.5, 1.5), Vector2(1.0, 1.0), Squash_time, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT);
		tween.start();
	
	if Input.is_action_just_released("Jump"):
		if velocity.y < 0:
			velocity.y += 200
	
	velocity = move_and_slide(velocity, Vector2.UP);

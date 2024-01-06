
extends KinematicBody2D

var velocity : Vector2

export var max_speed : int = 1000
export var gravity : float = 55
export var jump_force : int = 1000
export var acceleration : int = 10
export var jump_buffer_time : int  = 15
export var cayote_time : int = 15
export var friction: float = 0.2

var jump_buffer_counter : int = 0
var cayote_counter : int = 0

func _physics_process(_delta):
	
	if is_on_floor():
		cayote_counter = cayote_time

	if not is_on_floor():
		if cayote_counter > 0:
			cayote_counter -= 1
		
		velocity.y += gravity
		if velocity.y > 2000:
			velocity.y = 2000

	if Input.is_action_pressed("ui_right"):
		velocity.x += acceleration 
		$Sprite.flip_h = false

	elif Input.is_action_pressed("ui_left"):
		velocity.x -= acceleration
		$Sprite.flip_h = true

	else:
		velocity.x = lerp(velocity.x,0, friction)
	
	velocity.x = clamp(velocity.x, -max_speed, max_speed)
	
	if Input.is_action_just_pressed("ui_up"):
		jump_buffer_counter = jump_buffer_time
	
	if jump_buffer_counter > 0:
		jump_buffer_counter -= 1
	
	if jump_buffer_counter > 0 and cayote_counter > 0:
		velocity.y = -jump_force
		jump_buffer_counter = 0
		cayote_counter = 0
	
	if Input.is_action_just_released("ui_up"):
		if velocity.y < 0:
			velocity.y += 400
	
	velocity = move_and_slide(velocity, Vector2.UP)

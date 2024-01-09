extends KinematicBody2D
class_name BlackPlayer



#----------------------------------VARIABLES-----------------------------------#




const Squash_time : float = 0.4 

var velocity : Vector2
var direction : Vector2


#------------Sideways Movement Var---------------#

export var max_speed : int = 350
var moving : bool = false
export var acceleration : int = 15
export var friction: float = .3


#------------Jump and Gravity Var----------------#

export var jump_buffer_time : int  = 10
export var cayote_time : int = 7
export var gravity : float = 55
var jump_buffer_counter : int = 0
var cayote_counter : int = 0
export var jump_force : int = 700
var max_jumps : int = 2
var jumps_left : int = 0
var is_jumping : bool = false
var can_jump : bool = false




#------------Dash Var-----------------#

var is_dashing : bool = false
var can_dash : bool = false
export var dash_speed : int = 2000






onready var remote_transform = $RemoteTransform2D











#----------------------------------READY FUNCTION-----------------------------#
func _ready() -> void:
	pass






#--------------------------------PROCESS FUNCTION------------------------------#
func _process(delta) -> void:
	if Global.ActivePlayer == "white":
		set_physics_process(false)
	else:
		set_physics_process(true)
	
	Global.BlackPlayerPos = position























#----------------------------PHYSICS PROCESS FUNCTION-------------------------#


func _physics_process(_delta):
	
	if Global.PlayerHealth <= 0:
		get_tree().reload_current_scene() 
	
	#We don't have a label for the health yet...
	#$"../Label".text = str(Global.PlayerHealth) 
	
	Adjust_Collision_Shapes() 
	
	direction.x = Input.get_action_strength("right") - Input.get_action_strength("left")
	
	if is_on_floor():
		jumps_left = 2 
		is_jumping = false
		can_dash = true
		cayote_counter = cayote_time
	else:
		if cayote_counter > 0:
			cayote_counter -= 1
		
		if not OnWall():
			velocity.y += gravity
		if velocity.y > 4000:
			velocity.y = 4000
	
	Move()
	
	if OnRightWall():
		if direction.x == 1:
			velocity.y = gravity*2 
	elif OnLeftWall():
		if direction.x == -1:
			velocity.y = gravity*2 
	
	if Input.is_action_just_pressed("jump"):
		if not is_jumping:
			jump_buffer_counter = jump_buffer_time
		else:
			Jump()
	
	if jump_buffer_counter > 0:
		jump_buffer_counter -= 1
	
	if jumps_left > 0:
		can_jump = true 
	else:
		can_jump = false 

	if jump_buffer_counter > 0 and cayote_counter > 0:
		Jump() 
	
	if Input.is_action_just_released("jump"):
		if velocity.y < 0:
			velocity.y += 200
	
	if can_dash and $Dash_Timer.is_stopped():
		if Input.is_action_just_pressed("dash"):
			$Dash_Timer.start() 
			is_dashing = true 
			can_dash = false 
	velocity = move_and_slide(velocity, Vector2.UP) 
























#-----------------------------MOVEMENT FUNCTION--------------------------------#
func Move():
	if not is_dashing:
		velocity.x = clamp(velocity.x, -max_speed, max_speed)
		if Input.is_action_pressed("right"):
			moving = true
			if velocity.x >= 0:
				velocity.x += acceleration
			else:
				velocity.x += acceleration - velocity.x/3 
			$Sprite.flip_h = false
		elif Input.is_action_pressed("left"):
			moving = true
			if velocity.x <= 0:
				velocity.x -= acceleration
			else:
				velocity.x -= acceleration + velocity.x/3 
			$Sprite.flip_h = true
		else:
			moving = false
			velocity.x = lerp(velocity.x,0, friction)
	else:
		if direction.x != 0:
			if not $Dash_Timer.is_stopped():
				velocity.y = 0
			velocity.x = direction.x * dash_speed

func Jump():
	if can_jump:
		is_jumping = true 
		var tween = $Tween 
		tween.interpolate_property($Sprite, "scale", Vector2(1.0, 1.0), Vector2(.5, 1.5), Squash_time, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT) 
		tween.start() 
		jumps_left -= 1 
		velocity.y = -jump_force 
		jump_buffer_counter = 0 
		cayote_counter = 0 
		tween.interpolate_property($Sprite, "scale", Vector2(.5, 1.5), Vector2(1.0, 1.0), Squash_time, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT) 
		tween.start() 

func Adjust_Collision_Shapes():
	if moving:
		$LowerCollisionBox.disabled = true 
		$LowerCollisionCircle.disabled = false 
	else:
		$LowerCollisionBox.disabled = false 
		$LowerCollisionCircle.disabled = true 

func OnLeftWall() -> bool:
	if $LeftCast.is_colliding():
		return true 
	else:
		return false 

func OnRightWall() -> bool:
	if $RightCast.is_colliding():
		return true 
	else:
		return false 

func OnWall() -> bool:
	if OnLeftWall() or OnRightWall():
		return true 
	else:
		return false 

func _on_Dash_Timer_timeout():
	is_dashing = false 





func ConnectCamera(camera) -> void:
	var CameraPath = camera.get_path()
	remote_transform.remote_path = CameraPath



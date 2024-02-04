extends KinematicBody2D
class_name WhitePlayer




# The players codes are the same, so I think no need to comment this too


#----------------------------------VARIABLES-----------------------------------#


const Squash_time : float = 0.2

var is_attacking : bool = false;

var velocity : Vector2
var direction : Vector2
var projectile_dir : Vector2


var projectile = preload("res://Scenes/PlayerProjectile.tscn");

var TrampolineBoost: = 1500






#------------Sideways Movement Var---------------#

export var max_speed : int = 350
var moving : bool = false
export var acceleration : int = 15
export var friction: float = .3








#------------Jump and Gravity Var----------------#

export var jump_buffer_time : int  = 10
export var coyote_time : int = 7
export var gravity : float = 55
var jump_buffer_counter : int = 0
var coyote_counter : int = 0
export var jump_force : int = 700
var max_jumps : int = 2
var jumps_left : int = 0
var is_jumping : bool = false
var can_jump : bool = false







#------------Dash Var-----------------#

var is_dashing : bool = false
var can_dash : bool = false
export var dash_speed : int = 1000

onready var invincible_timer = $Invincible_Timer
onready var remote_transform = $RemoteTransform2D

#------------------------------READY FUNCTION----------------------------------#

func _ready() -> void:
	pass

#------------------------------PROCESS FUNCTION--------------------------------#
func _process(delta) -> void:
	
	#Disabling Physics Process when User swicthes player
	if Global.ActivePlayer == "Black":
		set_physics_process(false)
	else:
		set_physics_process(true)
	
	Global.WhitePlayerPos = global_position
	

#-------------------------------PHYSICS PROCESS--------------------------------#
func _physics_process(_delta):
	
	#Check the Boss Room scene... but whatever, it's just for testing
	#$"../Label".text = str(Global.PlayerHealth) 
	
	Adjust_Collision_Shapes() 
	
	if direction.y == 0:
		if $Sprite.flip_h:
			direction.x = -1;
		else:
			direction.x = 1;
	else:
		direction.x = 0;
	
	direction.y = Input.get_action_strength("down") - Input.get_action_strength("up");
	
	if is_on_floor():
		jumps_left = 2;
		is_jumping = false
		can_dash = true
		coyote_counter = coyote_time
	else:
		if coyote_counter > 0:
			coyote_counter -= 1
		
		if not OnWall():
			velocity.y += gravity
		if velocity.y > 1000:
			velocity.y = 1000
	
	Move()
	
	if not is_dashing:
		TrampolineCheck()
	
	if Global.WhiteHit:
		velocity.x = Global.knock_back_dir * Global.knock_back_force * 20;
		invincible_timer.start();
		Global.WhiteHit = false;
	
	if not invincible_timer.is_stopped():
		$Sprite.modulate.a = 0.2;
		$HurtBox/CollisionShape2D.disabled = true;
	
	if OnRightWall():
		if direction.x == 1:
			velocity.y = gravity*2;
	elif OnLeftWall():
		if direction.x == -1:
			velocity.y = gravity*2;
	
	if Input.is_action_just_pressed("jump"):
		if not is_jumping:
			jump_buffer_counter = jump_buffer_time
		else:
			Jump() 
	
	if jump_buffer_counter > 0:
		jump_buffer_counter -= 1
	
	if jumps_left > 0:
		can_jump = true;
	else:
		can_jump = false;
	
	if jump_buffer_counter > 0 and coyote_counter > 0:
		Jump() 
	
	if Input.is_action_just_released("jump"):
		if velocity.y < 0:
			velocity.y += 200
	
	if can_dash and $Dash_Timer.is_stopped():
		if Input.is_action_just_pressed("dash"):
			$Dash_Timer.start() 
			is_dashing = true;
			can_dash = false;
	
	velocity = move_and_slide(velocity, Vector2.UP)
	
	if Input.is_action_just_pressed("attack"):
		is_attacking = true;
	elif Input.is_action_just_released("attack"):
		is_attacking = false;
	
	if is_attacking:
		if direction.x > 0:
			$RightHitBox/CollisionShape2D.disabled = false;
			$LeftHitBox/CollisionShape2D.disabled = true;
		elif direction.x < 0:
			$LeftHitBox/CollisionShape2D.disabled = false;
			$RightHitBox/CollisionShape2D.disabled = true;
	else:
		$LeftHitBox/CollisionShape2D.disabled = true;
		$RightHitBox/CollisionShape2D.disabled = true;
	
	if Global.WhitePlayerHealth <= 0:
		$HurtBox/CollisionShape2D.disabled = true;
	
	if Input.is_action_just_pressed("shoot"):
		Global.instance_shoot(get_parent(), Vector2(global_position.x, global_position.y - 12), direction, projectile);

#---------------------------MOVEMENT FUNCTION----------------------------------#

func Move():
	if not is_dashing:
		$HurtBox/CollisionShape2D.disabled = false;
		velocity.x = clamp(velocity.x, -max_speed, max_speed)
		if Input.is_action_pressed("right"):
			moving = true
			if velocity.x >= 0:
				velocity.x += acceleration
			else:
				velocity.x += acceleration - velocity.x/3;
			$Sprite.flip_h = false
		elif Input.is_action_pressed("left"):
			moving = true
			if velocity.x <= 0:
				velocity.x -= acceleration
			else:
				velocity.x -= acceleration + velocity.x/3;
			$Sprite.flip_h = true
		else:
			moving = false
			velocity.x = lerp(velocity.x,0, friction)
	else:
		if direction.x != 0:
			velocity.y = 0
			$DashTrail.emitting = true;
			$HurtBox/CollisionShape2D.disabled = true;
			velocity.x = direction.x * dash_speed


#--------------------------------JUMP FUNCTION--------------------------------#
func Jump():
	if can_jump:
		is_jumping = true;
		var tween = $Tween;
		tween.interpolate_property($Sprite, "scale", Vector2(1.0, 1.0), Vector2(.5, 1.5), Squash_time, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT) 
		tween.start() 
		jumps_left -= 1;
		velocity.y = -jump_force;
		jump_buffer_counter = 0;
		coyote_counter = 0;
		tween.interpolate_property($Sprite, "scale", Vector2(.5, 1.5), Vector2(1.0, 1.0), Squash_time, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT) 
		tween.start() 





func Adjust_Collision_Shapes():
	if moving:
		$LowerCollisionBox.disabled = true;
		$LowerCollisionCircle.disabled = false;
	else:
		$LowerCollisionBox.disabled = false;
		$LowerCollisionCircle.disabled = true;







func OnLeftWall() -> bool:
	if $LeftCast.is_colliding():
		return true;
	else:
		return false;



func OnRightWall() -> bool:
	if $RightCast.is_colliding():
		return true;
	else:
		return false;




func OnWall() -> bool:
	if OnLeftWall() or OnRightWall():
		return true;
	else:
		return false;







func TrampolineCheck() -> void:
	if Global.OnTrampoline == "White":
		velocity.y = -TrampolineBoost
		if is_on_floor():
			Global.OnTrampoline = "None"
	else:
		pass













func _on_Dash_Timer_timeout():
	is_dashing = false;



func _on_RightHitBox_area_entered(area):
	if area.is_in_group("EnemyHurtBox"):
		area.get_parent().take_damage(Global.BlackPlayerMinDamage, Global.BlackPlayerMaxDamage, direction);

func _on_LeftHitBox_area_entered(area):
	if area.is_in_group("EnemyHurtBox"):
		area.get_parent().take_damage(Global.BlackPlayerMinDamage, Global.BlackPlayerMaxDamage, direction);


func _on_Invincible_Timer_timeout():
	$Sprite.modulate.a = 1
	$HurtBox/CollisionShape2D.disabled = false;

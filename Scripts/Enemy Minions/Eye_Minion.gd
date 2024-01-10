extends KinematicBody2D



#----------------------------------VARIABLES-----------------------------------#

const Squash_time : float = 0.2

# Health and damage variables

const max_health : float = 30.00

var health : float = max_health;

var min_damage : float = 4.00
var max_damage : float = 7.00

var KnockBackForce : float = 20.00
var knockBackDirection = Vector2.ZERO

var EnemyDamaged : bool = false;

var is_chasing_white = false;
var is_chasing_black = false;
var is_chasing = false;

var velocity : Vector2
var direction : Vector2
var random_dir = [-1,1] # used this to prevent direction.x = 0, and also for making the emeny wander around randomly


#------------Sideways Movement Var---------------#

export var speed : int = 80
var moving : bool = false


#------------Jump and Gravity Var----------------#
export var gravity : float = 55
export var jump_force : int = 400
var is_jumping : bool = false;
var can_jump : bool = false;


var timer;

func _ready():
	if not is_chasing:
		timer = rand_range(4,7)
	else:
		timer = 1
	$HealthBar.visible = false;
	$HealthBar.max_value = max_health;

func _process(delta):
	$HealthBar.value = lerp($HealthBar.value, health, 0.2);


#----------------------------PHYSICS PROCESS FUNCTION-------------------------#


func _physics_process(delta):
	
	# starting the timer
	timer -= 2*delta;
	
	is_chasing = is_chasing_white or is_chasing_black
	
	if not is_jumping:
		if is_chasing:
			# chase the player
			if Global.ActivePlayer=="White":
				direction.x = sign(Global.WhitePlayerPos.x - global_position.x);
			else:
				direction.x = sign(Global.BlackPlayerPos.x - global_position.x);
		else:
			# wander around
			if timer <= 0 and is_on_floor():
				direction.x = random_dir[randi()%2];
	
	if direction.x == 1:
		$Sprite.flip_h = true;
	elif direction.x == -1:
		$Sprite.flip_h = false;
	
	velocity.y += gravity
	if velocity.y > 4000:
		velocity.y = 4000
	
	if is_jumping:
		if not EnemyDamaged:
			velocity.x = direction.x * speed
		else:
			# continue the knockback force until he touches the ground
			velocity.x = knockBackDirection.x * Global.enemy_knock_back_force * 5;
	else:
		# Resets the x velocity to nul if he is on floor (not jumping)
		velocity.x = lerp(velocity.x, 0, 0.2);
	
	if is_on_floor():
		if EnemyDamaged:
			EnemyDamaged = false;
		
		is_jumping = false;
		can_jump = true;
	
	# resets the timer
	
	if timer <= 0 and is_on_floor():
		Jump()
		if not is_chasing:
			timer = rand_range(4,7);
		else:
			timer = 1;
	
	if health <= 0:
		# You can add here an animation of death, of just, fades away idk
		queue_free();
	
	velocity = move_and_slide(velocity, Vector2.UP) 

# jump function

func Jump():
	if can_jump:
		is_jumping = true;
		var tween = $Tween 
		tween.interpolate_property($Sprite, "scale", Vector2(1.0, 1.0), Vector2(.5, 1.5), Squash_time, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT) 
		tween.start() 
		velocity.y = -jump_force 
		tween.interpolate_property($Sprite, "scale", Vector2(.5, 1.5), Vector2(1.0, 1.0), Squash_time, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT) 
		tween.start() 

# Take damage function

func take_damage(maxdamage : float, mindamage : float, dir : Vector2):
	$HealthBar.visible = true;
	knockBackDirection = dir;
	
	velocity.x = knockBackDirection.x * Global.enemy_knock_back_force * 5;
	velocity.y = -jump_force/2;
	
	health -= rand_range(mindamage, maxdamage);
	
	is_jumping = true;
	EnemyDamaged = true;

# hit the player if in range

func _on_HitBox_area_entered(area):
	if area.is_in_group("PlayerHurtBox"):
		if area.get_parent().name == "WhitePlayer":
			Global.HitPlayer("White", min_damage, max_damage, direction.x, KnockBackForce);
		else:
			Global.HitPlayer("Black", min_damage, max_damage, direction.x, KnockBackForce);



# Detecting and chasing the active player

func _on_Detector_body_entered(body):
	if Global.ActivePlayer == "White":
		if body is WhitePlayer:
			is_chasing_black = false;
			is_chasing_white = true;
	else:
		if body is BlackPlayer:
			is_chasing_black = true;
			is_chasing_white = false;

# Detecting the exit of the active player and go back to wandering around 

func _on_Detector_body_exited(body):
	if Global.ActivePlayer == "White":
		if body is WhitePlayer:
			is_chasing_black = false;
			is_chasing_white = false;
	else:
		if body is BlackPlayer:
			is_chasing_black = false;
			is_chasing_white = false;

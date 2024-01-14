extends KinematicBody2D


const max_health : float = 50.0


var health : float = max_health

var is_chasing_white: bool = false
var is_chasing_black: bool = false
var min_damage: int = 5
var max_damage: int = 9
var is_chasing = false


var gravity: = 55

export(int) var ChargeSpeed: int = 300

var direction: Vector2 = Vector2.RIGHT #dir can't be zero
var velocity: Vector2 = Vector2.ZERO


var KnockBackForce : float = 20.00
var knockBackDirection = Vector2.ZERO



func _ready() -> void:
	#reseting the health bar before the game starts...
	$HealthBar.max_value = max_health
	$HealthBar.value = max_health
	$HealthBar.visible = false




func _physics_process(delta) -> void:
	
	if is_chasing:
			# chase the player
		if Global.ActivePlayer=="White":
			direction.x = sign(Global.WhitePlayerPos.x - global_position.x)
			velocity.x = direction.x * ChargeSpeed
		else:
			direction.x = sign(Global.BlackPlayerPos.x - global_position.x)
			velocity.x = direction.x * ChargeSpeed
	else:
		velocity = Vector2.ZERO
		is_chasing = false
	
	
	if direction.x == 1:
		$AnimatedSprite.flip_h = false
	elif direction.x == -1:
		$AnimatedSprite.flip_h = true
	
	
	velocity.y += gravity
	if velocity.y > 4000:
		velocity.y = 4000
	
	
	move_and_slide(velocity, Vector2.UP)












# Detecting the exit of the active player and go back to wandering around 
func _on_PlayerDectector_body_entered(body):
	if Global.ActivePlayer == "White":
		is_chasing = true
		if body is WhitePlayer:
			is_chasing = true
			is_chasing_black = false
			is_chasing_white = true
	else:
		if body is BlackPlayer:
			is_chasing = true
			is_chasing_black = true
			is_chasing_white = false


func _on_PlayerDectector_body_exited(body):
	if Global.ActivePlayer == "White":
		if body is WhitePlayer:
			is_chasing = false
			is_chasing_black = false
			is_chasing_white = false
	else:
		if body is BlackPlayer:
			is_chasing = false
			is_chasing_black = false
			is_chasing_white = false


func _on_HitBox_area_entered(area):
	if area.is_in_group("PlayerHurtBox"):
		if area.get_parent().name == "WhitePlayer":
			Global.HitPlayer("White", min_damage, max_damage, direction.x, KnockBackForce)
		else:
			Global.HitPlayer("Black", min_damage, max_damage, direction.x, KnockBackForce)






func take_damage(maxdamage : float, mindamage : float, dir : Vector2):
	$HealthBar.visible = true
	knockBackDirection = dir
	
	velocity.x = knockBackDirection.x * Global.enemy_knock_back_force * 5
	velocity.y = 200/2
	
	health -= rand_range(mindamage, maxdamage)


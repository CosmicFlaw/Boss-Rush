extends Node



#----------- Players Variables -----------#
var WhitePlayerHealth: float = 100.00;
var BlackPlayerHealth: float = 100.00;

var WhitePlayerMinDamage : float = 10.00;
var WhitePlayerMaxDamage : float = 15.00;
var BlackPlayerMinDamage : float = 8.00;
var BlackPlayerMaxDamage : float = 15.00;

# these two variables are used to knockback the player on the right direction after he gets hit
var knock_back_dir : int = 0;
var knock_back_force : float = 0;

var WhiteDead : bool = false;
var BlackDead : bool = false;

var WhiteHit : bool = false;
var BlackHit : bool = false;

#----------- Enemy Variables -------------#
var enemy_knock_back_force : int = 50.00;
var EnemyHit : bool = false;

var ActivePlayer = "White"
var WhitePlayerPos: Vector2 = Vector2.ZERO
var BlackPlayerPos: Vector2 = Vector2.ZERO


func _ready():
	randomize();

func _process(_delta) -> void:
	if WhitePlayerHealth <= 0:
		WhiteDead = true;
		print("White is dead");
		Global.ActivePlayer = "Black";
	else:
		WhiteDead = false;
	
	if BlackPlayerHealth <= 0:
		BlackDead = true;
		print("Black is dead");
		Global.ActivePlayer = "White";
	else:
		BlackDead = false;
	
	if Input.is_action_just_pressed("PlayerSwitch") and (not WhiteDead) and (not BlackDead):
		PlayerSwitch()


func PlayerSwitch() -> void:
	if ActivePlayer == "White":
		ActivePlayer = "Black"
	else: ActivePlayer = "White"


# A function to apply damage and knockback to the player if they got hit

func HitPlayer(Player : String, MinDamage : float, MaxDamage : float, direction : int, KnockBack : float):
	if Player=="White":
		WhitePlayerHealth -= rand_range(MinDamage,MaxDamage);
		WhiteHit = true;
	elif Player=="Black":
		BlackPlayerHealth -= rand_range(MinDamage,MaxDamage);
		BlackHit = true;
	
	# those variables are also used in the Player's script
	knock_back_dir = direction;
	knock_back_force = KnockBack;

# a function to create an instance in the scene, usually used for projectiles.

func instance_create(parent, position : Vector2, direction : Vector2, instance):
	var inst = instance.instance();
	var pos = position;
	inst.global_position = position;
	inst.dir = direction
	parent.add_child(inst)
	return inst

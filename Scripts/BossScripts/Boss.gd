extends Node2D

var Vertical_RayCast = preload("res://Scenes/Enemies/Bosses/VerticalEnergyBeam.tscn");

onready var player = $"../Player";
onready var timer = $Timer
onready var Eye = $Eye
onready var EyeBall = $Eye/EyeBall
onready var animation_tree = $AnimationTree
onready var PlayerPos = $PlayerPos

const MAX_HEALTH : float = 300.00;

var Attacks=["Attack1","Attack2", "Attack3"];
var current_attack : String = ""
var health : float = MAX_HEALTH;

var attack1 = false
var attack2 = false
var attack3 = false
var is_attacking = false

var attacks_threshold : int = 2;
var idle_count : int = 0;

var state_machine;
var inst = 0;

func _ready():
	randomize();
	global_position = Vector2(512, 100);
	PlayerPos.global_position = player.global_position;
	state_machine = animation_tree.get("parameters/playback");

func _physics_process(delta):
	$"../Label".text = current_attack;
	$"../Label2".text = str(is_attacking);
	$"../Label3".text = str(attack2);
	if not is_attacking:
		inst = 0;
		PlayerPos.global_position = lerp(PlayerPos.global_position, player.global_position, 0.05);
		EyeBall.look_at(PlayerPos.global_position);
	else:
		PlayerPos.global_position = $Eye/EyeBall/EnergyBeam.get_collision_point();
		if attack2:
			EyeBall.global_rotation += .02;
		elif attack3:
			if (inst <= 7):
				Global.instance_create(get_parent().get_parent(), Vector2(rand_range(50, 975), rand_range(50, 100)), Vector2(rand_range(-1,1), rand_range(-1,1)), Vertical_RayCast);
				inst += 1
	pass

func inc_idle_count():
	idle_count += 1;
	if idle_count>attacks_threshold:
		idle_count = 0;
		attack(Attacks[randi()%Attacks.size()]);

func reset_attack_state():
	is_attacking = false
	attack1 = false
	attack2 = false
	attack3 = false

func reset_to_idle():
	state_machine.travel("Idle");

func attack(attack : String):
	if attack == "Attack2":
		attack2 = true;
	elif attack == "Attack3":
		attack3 = true;
	$Timer.wait_time = $AnimationPlayer.get_animation(attack).length;
	$Timer.start();
	is_attacking = true
	state_machine.travel(attack);
	current_attack = attack;



func _on_Timer_timeout():
	reset_to_idle();
	reset_attack_state();
	

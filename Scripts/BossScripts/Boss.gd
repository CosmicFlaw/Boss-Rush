extends Node2D

onready var player = $"../Player";
onready var animation_tree = $AnimationTree;

const SPEED = 1000;

var velocity = Vector2.ZERO;

var Attacks=["attack1","attack_2"];

var is_attacking : bool = false;

var attacks_threshold : int = 10;
var idle_count : int = 0;

func _physics_process(delta):
	
	global_position += velocity*delta;

func inc_idle_count():
	idle_count += 1;
	if idle_count>attacks_threshold:
		idle_count = 0;
		attack();

func attack():
	animation_tree.get("parameters/playback").travel("Attack 1");
	var PlayerPosDir = sign(player.global_position.x - global_position.x);
	var direction = Vector2(PlayerPosDir,0);
	velocity = direction * SPEED;


func _on_HitBox_area_entered(area):
	if area.is_in_group("Edges"):
		animation_tree.get("parameters/playback").travel("Idle");
		velocity = Vector2.ZERO;


func _on_Attack_1_Hit_Box_area_entered(area):
	if area.is_in_group("PlayerHurtBox"):
		Global.PlayerHealth -= 20;

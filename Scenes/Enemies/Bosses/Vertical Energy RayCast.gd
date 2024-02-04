extends RayCast2D

var is_casting := false setget set_is_casting
var collider = null;

var min_damage = 30;
var max_damage = 60;

func _ready():
	$WarningSign.visible = true;
	$HitBox/CollisionShape2D.disabled = true;
	is_casting = false
	$Particles2D.visible = false;
	$Line2D.visible = false;
	$Particles2D.scale = Vector2.ZERO;
	

func _physics_process(delta):
	var cast_point := cast_to
	force_raycast_update()
	if is_colliding():
		cast_point = to_local(get_collision_point())
		$Line2D.points[1] = cast_point
		$Particles2D.position = cast_point
		$WarningSign.position = cast_point
		$HitBox.position = cast_point
	else:
		$Line2D.points[1] = Vector2(1000,0);
		$WarningSign.position = Vector2(1000,0);


func set_is_casting(cast : bool) -> void:
	is_casting = cast
	
	if is_casting:
		#appear()
		pass
	else:
		#disappear()
		pass
	
	set_physics_process(is_casting)


func appear() -> void:
	$HitBox/CollisionShape2D.disabled = false;
	$WarningSign.visible = false;
	$Line2D.visible = true
	$Particles2D.visible = true
	$Tween.interpolate_property($Particles2D, "scale", Vector2(0,0), Vector2(1,1), 0.05);
	$Tween.interpolate_property($Line2D, "width", 0.0, 32.0, 0.05);
	$Timer.start()
	$Tween.start()

func disappear() -> void:
	$HitBox/CollisionShape2D.disabled = true;
	$Particles2D.visible = false
	$Tween.interpolate_property($Line2D, "width", 32.0, 0.0, 0.3)
	$Tween.interpolate_property($Particles2D, "scale", Vector2(1,1), Vector2(0,0), 0.3);
	$Tween.start()
	yield($Tween, "tween_all_completed")
	queue_free();
	

func _on_Timer2_timeout():
	appear();

func _on_Timer_timeout():
	disappear();


func _on_HitBox_area_entered(area):
	if area.is_in_group("PlayerHurtBox"):
		Global.HitPlayer("White", min_damage, max_damage, 1, 20);

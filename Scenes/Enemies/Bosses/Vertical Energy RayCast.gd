extends RayCast2D

var is_casting := false setget set_is_casting

var dir : Vector2

func _ready():
	appear();

func _physics_process(delta):
	var cast_point := cast_to
	force_raycast_update()
	if is_colliding():
		cast_point = to_local(get_collision_point())
		$Line2D.points[1] = cast_point
		$Line.points[1] = cast_point
		$Particles2D.position = cast_point
	else:
		$Line2D.points[1] = Vector2(1000,0);
		$Line.points[1] = Vector2(1000,0);


func set_is_casting(cast : bool) -> void:
	is_casting = cast
	
	if is_casting:
		appear()
	else:
		disappear()
	
	set_physics_process(is_casting)


func appear() -> void:
	is_casting = true
	$Line2D.visible = true
	$Particles2D.visible = true
	$Tween2.interpolate_property($Sprite, "scale", Vector2(0,0), Vector2(0.5, 0.5), 0.2);
	$Timer2.start()
	$Tween2.start()

func disappear() -> void:
	is_casting = false
	$Particles2D.visible = false
	$Tween.interpolate_property($Line2D, "width", 32.0, 0.0, 0.01)
	$Tween.interpolate_property($Particles2D, "scale", Vector2(1,1), Vector2(0,0), 0.01);
	$Tween.interpolate_property($Sprite, "scale", Vector2(0.5,0.5), Vector2(0, 0), 0.015);
	$Tween.start()
	yield($Tween, "tween_all_completed")
	queue_free();
	


func _on_Timer_timeout():
	disappear();


func _on_Timer2_timeout():
	$Tween.interpolate_property($Particles2D, "scale", Vector2(0,0), Vector2(1,1), 0.2);
	$Tween.interpolate_property($Line2D, "width", 0.0, 32.0, 0.2);
	$Timer.start();
	$Tween.start();

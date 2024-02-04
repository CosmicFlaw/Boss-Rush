extends RayCast2D

var is_casting := true setget set_is_casting
var collider = null;

var min_damage = 20
var max_damage = 60

func _ready():
	disappear();

func _physics_process(delta):
	var cast_point := cast_to
	force_raycast_update()
	if is_colliding():
		cast_point = to_local(get_collision_point())
		$Line2D.points[1] = cast_point
		$Particles2D.position = cast_point
		collider = get_collider();
		if is_casting:
			if collider.is_in_group("Player"):
				Global.HitPlayer("White", min_damage, max_damage, 1, 20);
	else:
		$Line2D.points[1] = Vector2(1000,0);
	

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
	$Tween.interpolate_property($Sprite, "scale", Vector2(0,0), Vector2(0.5, 0.5), 0.2);
	$Tween.interpolate_property($Particles2D, "scale", Vector2(0,0), Vector2(1,1), 0.2);
	$Tween.interpolate_property($Line2D, "width", 0.0, 32.0, 0.2);
	$Tween.start()

func disappear() -> void:
	is_casting = false
	$Particles2D.visible = false
	$Tween.interpolate_property($Line2D, "width", 32.0, 0.0, 0.01)
	$Tween.interpolate_property($Particles2D, "scale", Vector2(1,1), Vector2(0,0), 0.01);
	$Tween.interpolate_property($Sprite, "scale", Vector2(0.5,0.5), Vector2(0, 0), 0.015);
	$Tween.start()
	yield($Tween, "tween_all_completed")
	$Line2D.visible = true
	

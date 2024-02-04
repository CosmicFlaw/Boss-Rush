extends Line2D

onready var parent = get_parent();

var queue : Array
export var MAX_LENGTH : int = 10;

func _process(delta):
	global_position = Vector2.ZERO;
	global_rotation = 0;
	
	var pos = parent.global_position;
	
	queue.push_front(pos);
	
	if queue.size() > MAX_LENGTH:
		queue.pop_back();
	
	clear_points()
	
	for i in queue:
		add_point(i);

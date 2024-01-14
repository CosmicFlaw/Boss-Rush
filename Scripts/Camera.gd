extends Camera2D

onready var CamPosB = $"../BlackPlayer/Position2D";
onready var CamPosW = $"../WhitePlayer/Position2D";

# Follow the global position of Position2D based on the active player.

func _physics_process(delta):
	if Global.ActivePlayer == "White":
		global_position = lerp(global_position, CamPosW.global_position, 0.2);
	elif Global.ActivePlayer == "Black":
		global_position = lerp(global_position, CamPosB.global_position, 0.2);

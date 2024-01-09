extends Node

var PlayerHealth: int = 100;
var ActivePlayer = "white"
var WhitePlayerPos: Vector2 = Vector2(445, 55)
var BlackPlayerPos: Vector2 = Vector2.ZERO

func _process(_delta) -> void:
	if Input.is_action_just_pressed("PlayerSwitch"):
		PlayerSwitch()


func PlayerSwitch() -> void:
	if ActivePlayer == "white":
		ActivePlayer = "black" 
	else: ActivePlayer = "white"

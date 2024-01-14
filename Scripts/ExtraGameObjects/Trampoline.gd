extends StaticBody2D


export(int) var JumpBoost: int = 2000



func _ready() -> void:
	pass






func _on_PlayerDetector_body_entered(body):
	if Global.ActivePlayer == "White":
		if body is WhitePlayer:
			Global.OnTrampoline = "White"
			$AnimationPlayer.play("ACTIVE")
	else:
		if body is BlackPlayer:
			Global.OnTrampoline = "Black"
			$AnimationPlayer.play("ACTIVE")

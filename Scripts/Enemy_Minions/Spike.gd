extends StaticBody2D


export(float) var SpikeDamage: float = 5.0

 

func _ready() -> void:
	pass




func _on_HitBox_body_entered(body):
	if Global.ActivePlayer == "White":
		if body is WhitePlayer:
			Global.HitPlayer("White", SpikeDamage, SpikeDamage, 0, 20.0)
	else:
		if body is BlackPlayer:
			Global.HitPlayer("Black", SpikeDamage, SpikeDamage, 0, 20.0)

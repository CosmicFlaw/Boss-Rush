extends Sprite


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	$Label.visible = false




func _on_PlayerDetector_body_entered(body):
	if body is WhitePlayer or body is BlackPlayer:
		$Label.visible = true


func _on_PlayerDetector_body_exited(body):
	if body is WhitePlayer or body is BlackPlayer:
		$Label.visible = false


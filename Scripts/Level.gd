extends Node2D


onready var camera = $Camera2D
onready var PlayerW = $WhitePlayer
onready var PlayerB = $BlackPlayer

# Called when the node enters the scene tree for the first time.
func _ready():
	VisualServer.set_default_clear_color(Color.lightblue)


func _process(delta):
	if Global.ActivePlayer == "white":
		PlayerW.ConnectCamera(camera)
	else:
		PlayerB.ConnectCamera(camera)

extends Node2D


onready var camera = $Camera
onready var PlayerW = $WhitePlayer
onready var PlayerB = $BlackPlayer

# Called when the node enters the scene tree for the first time.
func _ready():
	VisualServer.set_default_clear_color(Color.lightblue)


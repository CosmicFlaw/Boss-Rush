extends Control

onready var SamuraiHealthBar = $SamuraiHealthBar;
onready var NinjaHealthBar = $NinjaHealthBar;

# Health bars

func _process(delta):
	SamuraiHealthBar.value = lerp(SamuraiHealthBar.value, Global.WhitePlayerHealth, 0.2);
	NinjaHealthBar.value = lerp(NinjaHealthBar.value, Global.BlackPlayerHealth, 0.2);

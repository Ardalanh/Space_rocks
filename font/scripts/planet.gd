extends StaticBody2D

var ROT_SPEED = deg2rad(10)
var Healt_point = 3000
signal Dead

func _ready():
	set_process(true)

func _process(delta):
	rotate(ROT_SPEED * delta)
	if Healt_point <= 0:
		emit_signal("Dead")
	global.planetHP = Healt_point

func take_damage(damage):
	Healt_point += -damage
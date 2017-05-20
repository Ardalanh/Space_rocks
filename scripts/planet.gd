extends StaticBody2D

var ROT_SPEED = deg2rad(10)
var Healt_point = 3000

signal Dead
signal planet_pos_signal

func _ready():
	emit_signal("planet_pos_signal", get_global_pos())
	set_process(true)

func _process(delta):
	rotate(ROT_SPEED * delta)
	if Healt_point <= 0:
		emit_signal("Dead")
		set_process(false)
	global.planetHP = Healt_point

func take_damage(damage):
	Healt_point += -damage
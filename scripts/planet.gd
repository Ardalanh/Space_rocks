extends StaticBody2D

var ROT_SPEED = deg2rad(10)
var max_hp = 30000
var healt_point = max_hp

signal Dead
signal planet_pos_signal

func _ready():
	var radius = get_node("collision").get_shape().get_radius()
	emit_signal("planet_pos_signal", get_global_pos(), radius)
	global.planet_max_hp = max_hp
	set_process(true)

func _process(delta):
	rotate(ROT_SPEED * delta)
	if healt_point <= 0:
		emit_signal("Dead")
		set_process(false)
	global.planetHP = healt_point


func take_damage(damage):
	healt_point += -damage
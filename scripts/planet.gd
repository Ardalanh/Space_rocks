extends StaticBody2D

var ROT_SPEED = deg2rad(10)
var max_hp = 30000
var current_hp = max_hp
var regeneration = 10

signal Dead
signal planet_pos_signal
signal planet_max_hp
signal planet_hp

func _ready():
	var radius = get_node("collision").get_shape().get_radius()
	emit_signal("planet_pos_signal", get_global_pos(), radius)
	emit_signal("planet_max_hp", max_hp)
	set_process(true)

func _process(delta):
	rotate(ROT_SPEED * delta)
	if current_hp <= 0:
		emit_signal("Dead")
		emit_signal("planet_hp", 0)
		set_process(false)
		return 0

	emit_signal("planet_hp", current_hp)

func take_damage(damage):
	current_hp += -damage
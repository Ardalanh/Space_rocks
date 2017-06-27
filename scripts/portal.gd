extends StaticBody2D

var MAX_HP = 1000 setget set_max_hp
var current_hp = MAX_HP
var regeneration = 20

func _ready():
	set_process(true)

func _process(delta):
	current_hp += (regeneration + global.wave_num * 50) * delta
	if current_hp <= 0:
		queue_free()

func set_max_hp(hp):
	MAX_HP = hp

func take_damage(damage):
	current_hp += -damage * 0.5
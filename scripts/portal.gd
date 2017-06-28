extends StaticBody2D

signal portal_destroyed

onready var hp_bar = get_node("control/hp_bar")

var MAX_HP = 50000 setget set_max_hp
var current_hp = MAX_HP
var regeneration = 20

func _ready():
	hp_bar.set_max(MAX_HP)
	set_process(true)

func _process(delta):
	current_hp += (regeneration + global.wave_num * 10) * delta
	current_hp = clamp(current_hp, current_hp, MAX_HP)
	if current_hp <= 0:
		queue_free()
		emit_signal("portal_destroyed")
	hp_bar.set_value(current_hp)

func set_max_hp(hp):
	MAX_HP = hp

func take_damage(damage):
	current_hp += -damage * 0.5
extends Node2D

onready var timer = get_node("timer")

var current_level = 0
var cooldown = [30, 25, 20, 15] setget ,get_cooldown
var bullet_rate_multiple = [0.7, 0.6, 0.5, 0.4]
var regenration = [40, 60, 80, 100]
var duration = [3, 4, 5, 6]

var player
var player_sprite
var player_modulate

func __init__(player_obj, level):
	current_level = level - 1
	player = player_obj
	timer.set_wait_time(duration[current_level])
	timer.start()

	player.set_bullet_rate( player.get_bullet_rate() * bullet_rate_multiple[current_level])
	player.health_reg += regenration[current_level]

	player_sprite = player.get_node("sprite")
	player_modulate = player_sprite.get_modulate()
	player_sprite.set_modulate(Color(210,255,0))

func __finish__():
	player.set_bullet_rate( player.get_bullet_rate() / bullet_rate_multiple[current_level])
	player.health_reg -= regenration[current_level]
	player_sprite.set_modulate(player_modulate)
	queue_free()

func get_cooldown():
	return cooldown[current_level]
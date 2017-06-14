extends Node2D

onready var timer = get_node("timer")

var player
var player_sprite
var player_modulate

var bullet_rate_multiple = 0.5
var regenration = 100

var duration = 5

func __init__(player_obj):
	player = player_obj
	timer.set_wait_time(duration)
	timer.start()

	player.set_bullet_rate( player.get_bullet_rate() * 0.5)
	player.health_reg += regenration

	player_sprite = player.get_node("sprite")
	player_modulate = player_sprite.get_modulate()
	player_sprite.set_modulate(Color(210,255,0))

func __finish__():
	player.set_bullet_rate( player.get_bullet_rate() / 0.5)
	player.health_reg -= regenration
	player_sprite.set_modulate(player_modulate)
	queue_free()

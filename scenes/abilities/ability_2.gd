extends Node2D

onready var timer = get_node("duration")

var player
var player_rot
var BLINK_DIST = 600
var blink_pos
var MAX_VEL = 2500
var VEL = Vector2()

func __init__(player_obj):
	player = player_obj
	player.set_fixed_process(false)
	player.set_process_input(false)
	player.set_collision_trigger(true)

	player_rot = player.get_rot() - PI/2
	blink_pos = player.get_pos() + Vector2(BLINK_DIST, 0).rotated(player_rot)
	player.look_at(blink_pos)

	VEL = Vector2(MAX_VEL, 0).rotated(player_rot)
	timer.start()

	set_fixed_process(true)

func _fixed_process(delta):
	var distance_to_blink = blink_pos - player.get_pos()
	player.move_camera(distance_to_blink, delta)

	player.move(VEL * delta)

func _on_duration_timeout():
	player.vel = Vector2()
	player.acc = Vector2()
	player.set_fixed_process(true)
	player.set_process_input(true)
	player.set_collision_trigger(false)
	queue_free()

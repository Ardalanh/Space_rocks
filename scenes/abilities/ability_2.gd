extends Node2D

onready var timer = get_node("duration")

var current_level = 0
var cooldown = [6, 5, 4, 3] setget ,get_cooldown
var MAX_VEL = [2500, 3000, 3500, 4000] # THis is the speed of the ability
var BLINK_DIST = [300, 400, 500, 600]

var fade = false
var player
var player_rot
var player_layers
var player_collisions
var blink_pos
var VEL = Vector2()

var texture
var my_sprite

func __init__(player_obj, level):
	current_level = level - 1
	player = player_obj
	player_layers = player.get_layer_mask()
	player_collisions = player.get_collision_mask()
	player_rot = player.get_rot() - PI/2
	blink_pos = player.get_pos() + Vector2(BLINK_DIST[current_level], 0).rotated(player_rot)

	player.set_fixed_process(false)
	player.set_process_input(false)
	player.remove_from_group("player")
	player.set_layer_mask(4)
	player.set_collision_mask(4)
	player.vel = Vector2()
	player.acc = Vector2()

	VEL = Vector2(MAX_VEL[current_level], 0).rotated(player_rot)
	timer.start()

	set_pos(player.get_pos())
	texture = player.get_node("body").get_texture()

	set_fixed_process(true)
	set_process(true)

func _process(delta):
	if fade == true:
		if get_node("sprite_container").get_child_count()==0:
			queue_free()
			return 0
		get_node("sprite_container").get_child(0).queue_free()
	else:
		set_effect()

func _fixed_process(delta):
	var distance_to_blink = blink_pos - player.get_pos()
	player.move_camera(distance_to_blink, delta)

	player.move(VEL * delta)
	set_pos(player.get_pos())

func set_effect():
	my_sprite = Sprite.new()
	get_node("sprite_container").add_child(my_sprite)
	my_sprite.set_texture(texture)
	my_sprite.set_as_toplevel(true)
	my_sprite.set_global_pos(get_global_pos())
	my_sprite.set_modulate(Color(200,0,0))
	my_sprite.set_opacity(0.5)
	my_sprite.set_rot(player_rot - PI/2)
	my_sprite.set_scale(Vector2(0.5, 0.5))

func _on_duration_timeout():
	set_fixed_process(false)
	fade = true
	player.set_fixed_process(true)
	player.set_process_input(true)
	player.add_to_group("player")
	player.set_layer_mask(player_layers)
	player.set_collision_mask(player_collisions)
	player.vel = Vector2(MAX_VEL[current_level], 0).rotated(player_rot)

func get_cooldown():
	return cooldown[current_level]
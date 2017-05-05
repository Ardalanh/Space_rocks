extends KinematicBody2D

const MAIN_THRUST = 300
const MAX_VEL = 150

var screen_size
var rot = 0
var pos = Vector2()
var vel = Vector2()
var acc = Vector2(0, 0)
var bounce = 1.1
var player
var planet_pos


func start_at(pos, player_obj, planet):
	set_pos(pos)
	randomize()
	set_process(true)
	planet_pos = planet
	player = player_obj

func _process(delta):

	var distance_to_player = player.get_global_pos() - get_pos()
	var direction_to_player = distance_to_player.normalized()
	distance_to_player = distance_to_player.length()

	var distance_to_planet = planet_pos - get_pos()
	var direction_to_planet = distance_to_planet.normalized()
	distance_to_planet = distance_to_planet.length()


	if distance_to_player > 1200:
		look_at(planet_pos)
		acc = MAIN_THRUST * direction_to_planet
	if distance_to_player < 600:
		look_at(player.get_global_pos())
		if distance_to_player > 100:
			acc = MAIN_THRUST * direction_to_player
		else:
			acc = vel * -1
	elif distance_to_planet > 600:
		look_at(planet_pos)
		acc = MAIN_THRUST * direction_to_planet
	else:
		look_at(planet_pos)
		acc = vel * -1

	vel += acc * delta
	if vel.length() > MAX_VEL:
		vel = vel.normalized() * MAX_VEL

	var motion = move(vel * delta)

	if is_colliding():
		var spread = pow(-1,randi()%2)
		var n = get_collision_normal()
		var coll = get_collider()
		coll.vel = vel.tangent() * spread
		vel = vel.tangent() * spread * -1
		move(n.slide(motion))
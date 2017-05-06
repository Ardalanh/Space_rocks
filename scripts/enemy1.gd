extends KinematicBody2D

signal explode

export (PackedScene) var bullet
onready var bullet_container = get_node("bullet_container")
onready var bullet_rate = get_node("bullet_rate")

const MAIN_THRUST = 300
const MAX_VEL = 150
const PLAYER_CHASE_MIN = 500
const PLAYER_CHASE_MAX = 1500
const ROT_SPEED = 2
const ACCURACY = 5

var screen_size
var rot = 0
var pos = Vector2()
var vel = Vector2()
var acc = Vector2(0, 0)
var bounce = 0.8
var player
var planet_pos

func start_at(pos, player_obj, planet):
	set_pos(pos)
	randomize()
	set_process(true)
	planet_pos = planet
	player = player_obj
	look_at(planet_pos)

func _process(delta):
	follow_target(delta)

	vel += acc * delta
	if vel.length() > MAX_VEL:
		vel = vel.normalized() * MAX_VEL

	var motion = move(vel * delta)

	if is_colliding():
		var spread = pow(-1,randi()%2)
		var n = get_collision_normal()
		var coll = get_collider()
		if coll.is_in_group('enemy'):
			coll.vel = vel.tangent() * spread * bounce
		vel = vel.tangent() * spread * -1
		move(n.slide(motion))

func follow_target(delta):
	var target_pos
	var target_in_range = false

	var distance_to_player = player.get_global_pos() - get_pos()
	var direction_to_player = distance_to_player.normalized()
	distance_to_player = distance_to_player.length()

	var distance_to_planet = planet_pos - get_pos()
	var direction_to_planet = distance_to_planet.normalized()
	distance_to_planet = distance_to_planet.length()

	if distance_to_player > PLAYER_CHASE_MAX:
		target_in_range = false
		target_pos = planet_pos
		acc = MAIN_THRUST * direction_to_planet
	elif distance_to_player < PLAYER_CHASE_MIN:
		target_in_range = true
		target_pos = player.get_global_pos()
		if distance_to_player > 100:
			acc = MAIN_THRUST * direction_to_player
		else:
			acc = vel * -1
	elif distance_to_planet > 600:
		target_in_range = false
		target_pos = planet_pos
		acc = MAIN_THRUST * direction_to_planet
	else:
		target_in_range = true
		target_pos = planet_pos
		acc = vel * -1

	var target_angel = get_angle_to(target_pos)
	rotate(target_angel * ROT_SPEED * delta)
	target_angel = rad2deg(target_angel)
	if target_angel < ACCURACY and target_angel > -ACCURACY and bullet_rate.get_time_left() == 0 and target_in_range:
		shoot()

func shoot():
	bullet_rate.start()
	var b = bullet.instance()
	bullet_container.add_child(b)
	b.start_at(get_rot() + rand_range(-PI/25, PI/25), get_node("gun").get_global_pos())

func explode():
	emit_signal("explode", get_pos(), vel)
	queue_free()
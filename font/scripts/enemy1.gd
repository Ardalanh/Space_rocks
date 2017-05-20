extends KinematicBody2D

signal explode

export (PackedScene) var bullet
onready var bullet_container = get_node("bullet_container")
onready var bullet_rate = get_node("bullet_rate")
onready var HP_BAR = get_node("control/hp_bar")
onready var player_agro = get_node("agro_time")

const MAIN_THRUST = 300
const MAX_VEL = 150
const PLAYER_AGRO_RANGE = 500
const PLAYER_AGRO_TIME = 0.5
const ROT_SPEED = 5
const ACCURACY = 5

var screen_size
var rot = 0
var pos = Vector2()
var vel = Vector2()
var acc = Vector2(0, 0)
var bounce = 0.8
var player
var planet_pos
var Health_Point = 1000
var Damage = 50

func start_at(pos, player_obj, planet):
	HP_BAR.set_val(Health_Point)
	set_pos(pos)
	randomize()
	set_process(true)
	planet_pos = planet
	player = player_obj
	look_at(planet_pos)
	player_agro.set_wait_time(PLAYER_AGRO_TIME)

func _process(delta):
	acc = follow_target(delta, find_target())

	vel += acc * delta
	if vel.length() > MAX_VEL:
		vel = vel.normalized() * MAX_VEL

	var motion = move(vel * delta)

	if is_colliding():
		var spread = pow(-1,randi()%2)
		var coll = get_collider()
		if coll.is_in_group('enemy'):
			coll.vel = vel.tangent() * spread * bounce
		vel = vel.tangent() * spread * -1
		move(get_collision_normal().slide(motion))

func find_target():
	if player.Dead:
		return planet_pos

	var self_pos = get_pos()
	var distance_to_planet = (planet_pos - self_pos).length()
	var player_pos = player.get_global_pos()
	var distance_to_player = (player_pos - self_pos).length()

	if distance_to_player < PLAYER_AGRO_RANGE or player_agro.get_time_left() == 0:
		player_agro.start()
		return player_pos
	else:
		return planet_pos

func follow_target(delta, target_pos):
	var target_dis = target_pos - get_pos()
	var target_dir = target_dis.normalized()
	target_dis = target_dis.length()
	var target_angel = get_angle_to(target_pos)

	rotate(target_angel * ROT_SPEED * delta)
	target_angel = rad2deg(target_angel)
	if target_angel < ACCURACY and target_angel > -ACCURACY and bullet_rate.get_time_left() == 0 and target_dis < 400:
		shoot()

	if target_dis < 300:
		return target_dir * -vel
	else:
		return target_dir * MAIN_THRUST

func shoot():
	bullet_rate.start()
	var b = bullet.instance()
	bullet_container.add_child(b)
	b.damage = Damage
	b.start_at(get_rot() + rand_range(-PI/25, PI/25), get_node("gun").get_global_pos())


func explode():
	queue_free()
	emit_signal("explode", get_pos(), vel)

func take_damage(damage):
#	calculat_damage(damage, type_damage, armor_type)# return damage
	Health_Point = Health_Point - damage
	HP_BAR.set_val(Health_Point)
	if Health_Point <= 0:
		explode()

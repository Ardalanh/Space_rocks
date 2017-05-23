extends KinematicBody2D

signal explode

enum _States{follow_planet,
			 attack_planet,
			 find_target,
			 chase_target,
			 chase_attack,
			 attack_action}

export (PackedScene) var bullet
onready var bullet_container = get_node("bullet_container")
onready var bullet_rate = get_node("bullet_rate")
onready var HP_BAR = get_node("control/hp_bar")
onready var player_agro = get_node("agro_time")

const MAIN_THRUST = 300
const MAX_VEL = 150
const PLAYER_AGRO_RANGE = 500
const PLAYER_AGRO_TIME = 0.5
const PLANET_AGRO_RANGE = 500
const MAIN_TARGET_AGRO_RANGE = 600
const MAIN_TARGET_ATTACK_RANGE = 400
const ROT_SPEED = 5
const ACCURACY = 5
const STOPING_FRICTION = 0.5

var screen_size
var rot = 0
var pos = Vector2()
var vel = Vector2()
var acc = Vector2(0, 0)
var bounce = 0.8

var target_list = []
var main_target
var planet_pos

var health_point = 1000
<<<<<<< HEAD
<<<<<<< HEAD
var damage = 100
=======
var damage = 10
>>>>>>> master
=======
var damage = 100
>>>>>>> master
var state = _States.follow_planet

func start_at(pos, planet):
	HP_BAR.set_val(health_point)
	set_pos(pos)
	randomize()
	set_process(true)
	planet_pos = planet
	look_at(planet_pos)
	player_agro.set_wait_time(PLAYER_AGRO_TIME)

func _process(delta):
	if state == _States.follow_planet:
		follow_planet_state(delta)
	elif state == _States.attack_planet:
		attack_planet_state(delta)
	elif state == _States.find_target:
		find_target_state()
	elif state == _States.chase_target:
		chase_target_state(delta)
	elif state == _States.chase_attack:
		chase_attack_state(delta)
	elif state == _States.attack_action:
		attack_action_state()

#States will set the acc variable
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

func follow_planet_state(delta):
	set_acceleration(planet_pos)

	look_at_target(delta, planet_pos)

	var distance_to_planet = (planet_pos - get_pos()).length()
	if distance_to_planet < PLANET_AGRO_RANGE:
		state = _States.attack_planet

func attack_planet_state(delta):
	set_acceleration(planet_pos, false) #false for decelerating

	look_at_target(delta, planet_pos)
	shoot()
	var distance_to_planet = (planet_pos - get_pos()).length()
	if distance_to_planet > PLANET_AGRO_RANGE:
		state = _States.follow_planet

func find_target_state():
	if target_list.empty():
		state = _States.follow_planet
		return 0
	for target in target_list:
		if target.get_name() == 'player':
			main_target = target
	state = _States.chase_target

func chase_target_state(delta):
	if main_target.dead:
<<<<<<< HEAD
		target_list.erase(main_target)
		main_target = null
		state = _States.find_target
		return 0
=======
		state = _States.find_target
		target_list.erase(main_target)
		main_target = null
		return 0

>>>>>>> master
	var main_target_pos = main_target.get_pos()
	set_acceleration(main_target_pos)

	look_at_target(delta, main_target_pos)
	
	var distance_to_main_target = (main_target_pos - get_pos()).length()
	if distance_to_main_target < MAIN_TARGET_ATTACK_RANGE:
		state = _States.chase_attack
	elif distance_to_main_target > MAIN_TARGET_AGRO_RANGE:
		target_list.erase(main_target)
		main_target = null
		state = _States.find_target

func chase_attack_state(delta):
	if main_target.dead:
<<<<<<< HEAD
		target_list.erase(main_target)
		main_target = null
		state = _States.find_target
=======
		state = _States.find_target
		target_list.erase(main_target)
		main_target = null
>>>>>>> master
		return 0
	var main_target_pos = main_target.get_pos()
	set_acceleration(main_target_pos)

	look_at_target(delta, main_target_pos)

	var distance_to_main_target = (main_target_pos - get_pos()).length()
	if distance_to_main_target < MAIN_TARGET_ATTACK_RANGE  and not main_target.dead:
		shoot()
	else:
		state = _States.chase_target

func attack_action_state():
	pass

func look_at_target(delta, target_pos):
	var angle_to_target = get_angle_to(target_pos)
	rotate(angle_to_target * ROT_SPEED * delta)

func set_acceleration(target_pos, is_thrusting=true):# is_thrusting is for acceleration or deceleration
	var distance_to_target = target_pos - get_pos()
	var direction_to_target = distance_to_target.normalized()
	distance_to_target = distance_to_target.length()

	if is_thrusting:
		acc = direction_to_target * MAIN_THRUST
	else:
		acc = -vel * STOPING_FRICTION

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

	if bullet_rate.get_time_left() == 0:
		bullet_rate.start()
		var b = bullet.instance()
		bullet_container.add_child(b)
		b.damage = damage
<<<<<<< HEAD
		print(main_target)
=======
>>>>>>> master
		b.start_at(get_rot() + rand_range(-PI/36, PI/36), get_node("gun").get_global_pos(), main_target)

func explode():
	queue_free()
	emit_signal("explode", get_pos(), vel)

func take_damage(damage):
#	calculat_damage(damage, type_damage, armor_type)# return damage
	health_point = health_point - damage
	HP_BAR.set_val(health_point)
	if health_point <= 0:
		explode()

func _on_Area2D_body_enter( body ):
	if body.is_in_group("player") :
		state = _States.find_target
		if not target_list.has(body):
			target_list.append(body)

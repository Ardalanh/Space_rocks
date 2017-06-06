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
onready var action_timer = get_node("action")

const MAIN_THRUST = 150
const MAX_VEL = 300
const MAIN_TARGET_AGRO_RANGE = 600
const ATTACK_RANGE = 300
const ROT_SPEED = 5
const STOPING_FRICTION = 2
const FLEE_FORCE = 50

var pos = Vector2()
var vel = Vector2()
var acc = Vector2(0, 0)

var target_list = []
var near_enemies_list = []
var main_target
var planet_pos
var planet_radius

var health_point = 1000
export var damage = 4
var state = _States.follow_planet

func start_at(pos, planet_p, planet_r):
	randomize()
#	damage += randi()%5
	HP_BAR.set_val(health_point)
	set_pos(pos)
	set_fixed_process(true)
	planet_pos = planet_p
	planet_radius = planet_r
	look_at(planet_pos)

func _fixed_process(delta):
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
		move(get_collision_normal().slide(motion))

	#pushing near enemies away
	for e in near_enemies_list:
		var flee_dir = e.get_pos() - get_pos()
		var flee_dist = flee_dir.length()
		flee_dir = flee_dir.normalized()
		e.vel += flee_dir * FLEE_FORCE/flee_dist

func follow_planet_state(delta):
	steer(planet_pos, planet_radius)
#	set_acceleration(planet_pos)

	look_at_target(delta, planet_pos)

	var distance_to_planet = (planet_pos - get_pos()).length()
	if distance_to_planet < ATTACK_RANGE + planet_radius:
		state = _States.attack_planet

func attack_planet_state(delta):
	steer(planet_pos, planet_radius)

	look_at_target(delta, planet_pos)
	shoot()
	var distance_to_planet = (planet_pos - get_pos()).length()
	if distance_to_planet > ATTACK_RANGE + planet_radius:
		state = _States.follow_planet

func find_target_state():
	if target_list.empty():
		state = _States.follow_planet
		return 0
	for target in target_list:
		if target.is_in_group('player'):
			main_target = target
	state = _States.chase_target

func chase_target_state(delta):
	if main_target.dead:
		state = _States.find_target
		target_list.erase(main_target)
		main_target = null
		return 0

	var main_target_pos = main_target.get_pos()
	steer(main_target_pos)

	look_at_target(delta, main_target_pos)

	var distance_to_main_target = (main_target_pos - get_pos()).length()
	if distance_to_main_target < ATTACK_RANGE:
		state = _States.chase_attack
	elif distance_to_main_target > MAIN_TARGET_AGRO_RANGE:
		target_list.erase(main_target)
		main_target = null
		state = _States.find_target

func chase_attack_state(delta):
	if main_target.dead:
		state = _States.find_target
		target_list.erase(main_target)
		main_target = null
		action_timer.stop()
		return 0
	var main_target_pos = main_target.get_pos()

	steer(main_target_pos)

	look_at_target(delta, main_target_pos)

	var distance_to_main_target = (main_target_pos - get_pos()).length()
	if distance_to_main_target < ATTACK_RANGE:
		shoot()
	else:
		state = _States.chase_target
		action_timer.stop()
		return 0

	if action_timer.get_time_left() == 0:
		action_timer.start()

func attack_action_state():
	cast_ability(1)
	state = _States.chase_attack

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

func steer(target, target_raduis=0):
	var desired = target - get_pos()
	var distance_to_target = desired.length() - target_raduis
	desired = desired.normalized()
	if distance_to_target > ATTACK_RANGE :
		desired *= MAX_VEL
	elif distance_to_target < (ATTACK_RANGE) * 0.5:
		desired *= ((distance_to_target)  * MAX_VEL * -0.5 / ATTACK_RANGE)
	else:
		acc = -vel * STOPING_FRICTION
		return 0

	var steer = (desired - vel)
	if steer.length() > MAIN_THRUST:
		steer = steer.normalized() * MAIN_THRUST
	acc = steer

func shoot():
	if bullet_rate.get_time_left() == 0:
		bullet_rate.start()
		var b = bullet.instance()
		bullet_container.add_child(b)
		b.damage = damage
		b.start_at(get_rot() + rand_range(-PI/36, PI/36), get_node("gun").get_global_pos(), main_target)
#		vel += Vector2(50, 0).rotated(get_rot() + PI/2)

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
	elif body.is_in_group("enemy") and (body.get_name() != get_name()) :
		if not near_enemies_list.has(body):
			near_enemies_list.append(body)

func _on_agro_range_body_exit( body ):
	if body.is_in_group("enemy"):
		if near_enemies_list.has(body):
			near_enemies_list.erase(body)

func _on_action_timeout():
	if state == _States.chase_attack:
		state = _States.attack_action

func cast_ability(index):
	var ability = generate_ability(index)
	bullet_container.add_child(ability)
	ability.__init__(self)

func generate_ability(index):
	return load("res://scenes/creep_scenes/enemy_ability_%d.tscn"%index).instance()
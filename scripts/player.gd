extends KinematicBody2D

signal player_dead
signal player_alive

export (PackedScene) var bullet
var ability_1 = preload("res://scenes/abilities/ability_1.tscn")
var ability_2 = preload("res://scenes/abilities/ability_2.tscn")
var ability_3 = preload("res://scenes/abilities/ability_3.tscn")
onready var bullet_container = get_node("bullet_container")
onready var bullet_rate = get_node("bullet_rate")
onready var shoot_sound = get_node("shoot_sound")
onready var player_camera = get_node("camera")
onready var HP_BAR = get_node("control/hp_bar")
onready var ability = get_node("ability_node")
onready var animation = get_node("moving_animations")
onready var gun_anim = get_node("gun_anim")

var screen_size
var rot = 0
var pos = Vector2()
var vel = Vector2()
var acc = Vector2(0, 0)
var shoot_key_pressed = false
var dead = false
var respawn_time = 3
var camera_offset = Vector2()
var alter_gun = 1
onready var respawn_pos = get_pos()

var MAIN_THRUST = 800
var MAX_VEL = 600
var damage = 500
var MAX_HP = 500
var health_reg = 0
var health_point
var level = 1

func _ready():
	health_point = MAX_HP
	HP_BAR.set_max(MAX_HP)
	HP_BAR.set_val(health_point)
	screen_size = OS.get_window_size()

	animation.play("idle")

	set_fixed_process(true)
	set_process(true)
	set_process_unhandled_input(true)


func _unhandled_input(event):
	if event.is_action_pressed("player_ability_1"):
		cast_ability(1)
	elif event.is_action_pressed("player_ability_2"):
		cast_ability(2)
	elif event.is_action_pressed("player_ability_3"):
		cast_ability(3)
	elif event.is_action_released("player_shoot"):
		shoot_key_pressed = false
	elif event.is_action_pressed("player_shoot"):
		shoot_key_pressed = true

	elif event.is_action_pressed("player_thrust"):
		animation.play("thrusting")
	elif event.is_action_released("player_thrust"):
		animation.play("thrust_to_idle")
	elif event.is_action_pressed("player_thrust_rev"):
		animation.play("stoping")
	elif event.is_action_released("player_thrust_rev"):
		animation.play("stop_to_idle")


func _process(delta):
	screen_size = get_viewport_rect().size
	if shoot_key_pressed  and bullet_rate.get_time_left() == 0:
		shoot()

	health_point += health_reg * delta
	health_point = clamp(health_point, 0, MAX_HP)
	HP_BAR.set_val(health_point)

func _fixed_process(delta):
	var mouse_pos = get_global_mouse_pos()
	var mouse_angel = get_angle_to(mouse_pos)
	rotate(clamp(mouse_angel,-0.2,0.2))

	var distance_to_mouse = mouse_pos - get_pos()
	var direction_to_mouse = distance_to_mouse.normalized()
	move_camera(distance_to_mouse, delta)

	if Input.is_action_pressed("player_thrust"):
		acc = direction_to_mouse * MAIN_THRUST
	else:
		acc = Vector2(0, 0)

	vel += acc * delta

	if Input.is_action_pressed("player_thrust_rev"): # to stop the ship\ put reverse force
		vel += vel.normalized() * -MAIN_THRUST / 2 * delta
		if vel.length() < 10:
			vel = Vector2(0, 0)

	if vel.length() > MAX_VEL:
		vel = vel.normalized() * MAX_VEL #max

	var motion = move(vel * delta)
	if is_colliding():
		var coll = get_collider()
		var n = get_collision_normal()
		if coll.is_in_group('enemy'):
			coll.vel += vel * 0.5
		vel = n.slide(vel)
		move(n.slide(motion))

func shoot():
	var init_angel = get_rot()
	if alter_gun == 1:
		alter_gun = 2
		init_angel += 0.03
	else:
		alter_gun = 1
		init_angel -= 0.03
	var gun = "gun_%d"%alter_gun
	gun_anim.play(gun)

	bullet_rate.start()
	var b = bullet.instance()
	bullet_container.add_child(b)
	b.start_at(init_angel, get_node(gun).get_global_pos())
	b.damage = damage + level*50
	shoot_sound.play("shoot1", true)


func take_damage(damage):
	health_point = health_point - damage
	if health_point <= 0 and not dead:
		dead()

func dead():
	dead = true
	set_process(false)
	set_fixed_process(false)
	set_process_unhandled_input(false)
	hide()
	set_layer_mask(0)
	set_collision_mask(0)
	get_node("camera").clear_current()
	emit_signal("player_dead", respawn_time)
	get_node("respawn_time").set_wait_time(respawn_time)
	get_node("respawn_time").start()

func alive():
	dead = false
	set_pos(respawn_pos)
	vel = Vector2()
	acc = Vector2()
	shoot_key_pressed = false
	_ready()
	self.show() #default function
	set_layer_mask(3)
	set_collision_mask(3)
	emit_signal("player_alive")
	get_node("camera").make_current()

func move_camera(mouse_dist, delta):
	var max_offset = (screen_size * 2).length()
	var mouse_len = clamp(mouse_dist.length(), 5, max_offset)
	mouse_len = (1/max_offset) * pow(mouse_len, 2)
	var offset_ratio = mouse_len/mouse_dist.length()
	var desired_offset = mouse_dist * offset_ratio
	camera_offset += (desired_offset - camera_offset) * delta * 10
	player_camera.set_offset(camera_offset)

func cast_ability(index):
	ability.cast(index)

func set_bullet_rate(num):
	bullet_rate.set_wait_time(num)

func get_bullet_rate():
	return bullet_rate.get_wait_time()


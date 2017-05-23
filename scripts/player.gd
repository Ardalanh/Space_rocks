extends KinematicBody2D

signal player_dead
signal player_alive

const MAX_CAMERA = 600

export (PackedScene) var bullet
onready var bullet_container = get_node("bullet_container")
onready var bullet_rate = get_node("bullet_rate")
onready var respawn = get_node("respawn")
onready var shoot_sound = get_node("shoot_sound")
onready var player_camera = get_node("camera")
onready var HP_BAR = get_node("control/hp_bar")

var screen_size
var rot = 0
var pos = Vector2()
var vel = Vector2()
var acc = Vector2(0, 0)
var shoot_key_pressed = false
var dead = false
<<<<<<< HEAD
=======
var respawn_time = 10
>>>>>>> master

var MAIN_THRUST = 1200
var MAX_VEL = 300
var damage = 500
var MAX_HP = 500
var health_point

func _ready():
	health_point = MAX_HP
	HP_BAR.set_max(MAX_HP)
	HP_BAR.set_val(health_point)
	respawn.set_wait_time(respawn_time)
	screen_size = get_viewport_rect().size
	pos = screen_size / 2
	print("ready excuted")
	set_pos(pos)
	set_fixed_process(true)
	set_process(true)
	set_process_unhandled_input(true)

func _unhandled_input(event):
	if event.is_action_released("player_shoot"):
		shoot_key_pressed = false
	if event.is_action_pressed("player_shoot"):
		shoot_key_pressed = true

func _process(delta):
	screen_size = get_viewport_rect().size
	if shoot_key_pressed  and bullet_rate.get_time_left() == 0:
		shoot()
	HP_BAR.set_val(health_point)

func _fixed_process(delta):
	var mouse_pos = get_global_mouse_pos()
	look_at(mouse_pos)

	var distance_to_mouse = mouse_pos - get_pos()
	var direction_to_mouse = distance_to_mouse.normalized()
	camera_offset(distance_to_mouse)


	if Input.is_action_pressed("player_thrust"):
		acc = direction_to_mouse * MAIN_THRUST
	else:
		acc = Vector2(0, 0)

	vel += acc * delta

	if Input.is_action_pressed("player_thrust_rev"): # to stop the ship\ put reverse force
		vel += vel.normalized() * -MAIN_THRUST / 2 * delta

	if vel.length() > MAX_VEL:
		vel = vel.normalized() * MAX_VEL #max
	var motion = move(vel * delta)
	if is_colliding():
		var coll = get_collider()
		var n = get_collision_normal()
		if coll.is_in_group('enemy'):
			coll.vel += vel
		vel = n.slide(vel)
		move(n.slide(motion))


func shoot():
	bullet_rate.start()
	var b = bullet.instance()
	bullet_container.add_child(b)
	b.start_at(get_rot(), get_node("gun").get_global_pos())
	b.damage = damage
<<<<<<< HEAD
	shoot_sound.play("shoot1" , true)
=======
	shoot_sound.play("shoot1", true)
>>>>>>> master

func take_damage(damage):
	health_point = health_point - damage
	if health_point <= 0:
		dead()

func dead():
	dead = true
<<<<<<< HEAD
=======
	set_process(false)
	set_fixed_process(false)
	set_process_unhandled_input(false)
	hide()
	get_node("collision").set_trigger(true)
	get_node("camera").clear_current()
	get_node("respawn").start()
	emit_signal("player_dead", respawn_time)

func respawn():
	dead = false
	pos = Vector2()
	vel = Vector2()
	acc = Vector2(0, 0)
	shoot_key_pressed = false
	_ready()
	show()
	get_node("collision").set_trigger(false)
	emit_signal("player_alive")
	get_node("camera").make_current()

>>>>>>> master

func camera_offset(mouse_dist):
	var max_offset = (screen_size * 2).length()

	var mouse_len = clamp(mouse_dist.length(), 5, max_offset)
	mouse_len = (1/max_offset) * pow(mouse_len, 2)
	var offset_ratio = mouse_len/mouse_dist.length()
	player_camera.set_offset(mouse_dist * offset_ratio)


func _on_respawn_timeout():
	respawn()

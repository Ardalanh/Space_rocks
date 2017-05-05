extends KinematicBody2D

const MAIN_THRUST = 2000/3
const MAX_VEL = 1000/3
export (PackedScene) var bullet
onready var bullet_container = get_node("bullet_container")
onready var bullet_rate = get_node("bullet_rate")
onready var shoot_sound = get_node("shoot_sound")
onready var player_camera = get_node("camera")

var screen_size
var rot = 0
var pos = Vector2()
var vel = Vector2()
var acc = Vector2(0, 0)
var power_up = 1
var shoot_key_pressed = false

func _ready():
	screen_size = get_viewport_rect().size
	pos = screen_size / 2
	set_pos(pos)
	set_fixed_process(true)
	set_process(true)
	set_process_input(true)

func _input(event):
	if event.is_action_released("player_shoot"):
		shoot_key_pressed = false
	if Input.is_action_pressed("player_shoot"):
		shoot_key_pressed = true

	if event.is_action_pressed("player_power_up_1"):
		power_up = 1
	if event.is_action_pressed("player_power_up_2"):
		power_up = 2

func _process(delta):

	if shoot_key_pressed  and bullet_rate.get_time_left() == 0:
		shoot()

func _fixed_process(delta):
	var mouse_pos = get_global_mouse_pos()
	look_at(mouse_pos)

	var distance_to_mouse = mouse_pos - get_pos()
	var direction_to_mouse = distance_to_mouse.normalized()
	player_camera.set_offset(distance_to_mouse / 3)
	distance_to_mouse = distance_to_mouse.length()

	if Input.is_action_pressed("player_thrust"):
		acc = direction_to_mouse * MAIN_THRUST
	else:
		acc = Vector2(0, 0)

	vel += acc * delta
	if vel.length() > MAX_VEL:
		vel = vel.normalized() * MAX_VEL #max
	move(vel * delta)

func shoot():
	bullet_rate.start()
	if power_up == 1:
		var b = bullet.instance()
		bullet_container.add_child(b)
		b.start_at(get_rot(), get_node("mid_gun").get_global_pos())
	elif power_up == 2:
		var b1 = bullet.instance()
		var b2 = bullet.instance()
		bullet_container.add_child(b1)
		bullet_container.add_child(b2)
		b1.start_at(get_rot(), get_node("left_gun").get_global_pos())
		b2.start_at(get_rot(), get_node("right_gun").get_global_pos())
	shoot_sound.play("shoot%s" % (str(randi()%2 + 1)) , true)

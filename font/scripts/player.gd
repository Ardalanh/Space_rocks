extends KinematicBody2D

signal player_dead

const MAX_CAMERA = 600

const MAIN_THRUST = 1200
const MAX_VEL = 300
export (PackedScene) var bullet
onready var bullet_container = get_node("bullet_container")
onready var bullet_rate = get_node("bullet_rate")
onready var shoot_sound = get_node("shoot_sound")
onready var player_camera = get_node("camera")
onready var HP_BAR = get_node("control/hp_bar")

var screen_size
var rot = 0
var pos = Vector2()
var vel = Vector2()
var acc = Vector2(0, 0)
var shoot_key_pressed = false
var damage = 1000
var Health_point = 500
var Dead = false

func _ready():
	HP_BAR.set_val(Health_point)
	screen_size = get_viewport_rect().size
	pos = screen_size / 2
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
		var n = get_collision_normal()
		vel = n.slide(vel)
		move(n.slide(motion))


func shoot():
	bullet_rate.start()
	var b = bullet.instance()
	bullet_container.add_child(b)
	b.start_at(get_rot(), get_node("mid_gun").get_global_pos())
	b.damage = damage
	shoot_sound.play("shoot%s" % (str(randi()%2 + 1)) , true)

func take_damage(damage):
	Health_point = Health_point - damage
	HP_BAR.set_val(Health_point)
	if Health_point <= 0:
		Dead = true
		emit_signal("player_dead")

func camera_offset(mouse_dist):
	var max_offset = (screen_size * 2).length()

	var mouse_len = clamp(mouse_dist.length(), 5, max_offset)
	mouse_len = (1/max_offset) * pow(mouse_len, 2)
	var offset_ratio = mouse_len/mouse_dist.length()
	player_camera.set_offset(mouse_dist * offset_ratio)
extends KinematicBody2D

const MAIN_THRUST = 300
const MAX_VEL = 150

var screen_size
var rot = 0
var pos = Vector2()
var vel = Vector2()
var acc = Vector2(0, 0)
var bounce = 1.1

func _ready():
	randomize()
	set_process(true)

func start_at(pos):
	set_pos(pos)

func _process(delta):
	look_at(Vector2(0, 0))

	var distance = Vector2(0, 0) - get_pos()
	var direction = distance.normalized()
	distance = distance.length()

	if distance > 600:
		acc = MAIN_THRUST * direction
	else:
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
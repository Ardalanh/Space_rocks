extends KinematicBody2D

signal explode

export var bounce = 1.1

var size
var vel = Vector2()
var rot_speed
var screen_size
var extents
var textures = {
'big_grey': ['res://art/Spritesheet/sheet.meteorGrey_big1.atex',
             'res://art/Spritesheet/sheet.meteorGrey_big2.atex',
             'res://art/Spritesheet/sheet.meteorGrey_big3.atex',
             'res://art/Spritesheet/sheet.meteorGrey_big4.atex'],
'big_brown': ['res://art/PNG/Meteors/meteorBrown_big1.png',
              'res://art/PNG/Meteors/meteorBrown_big3.png',
              'res://art/PNG/Meteors/meteorBrown_big4.png'],
'med_grey': ['res://art/Spritesheet/sheet.meteorGrey_med1.atex',
             'res://art/Spritesheet/sheet.meteorGrey_med2.atex'],
'med_brown': ['res://art/PNG/Meteors/meteorBrown_med1.png',
              'res://art/PNG/Meteors/meteorBrown_med3.png'],
'small_grey': ['res://art/Spritesheet/sheet.meteorGrey_small1.atex',
               'res://art/Spritesheet/sheet.meteorGrey_small2.atex'],
'small_brown': ['res://art/PNG/Meteors/meteorBrown_small1.png',
                'res://art/PNG/Meteors/meteorBrown_small2.png'],
'tiny_grey': ['res://art/Spritesheet/sheet.meteorGrey_tiny1.atex',
              'res://art/Spritesheet/sheet.meteorGrey_tiny2.atex'],
'tiny_brown': ['res://art/PNG/Meteors/meteorBrown_tiny1.png',
               'res://art/PNG/Meteors/meteorBrown_tiny2.png']
                }

onready var puff = get_node("puff")

func _ready():
	add_to_group("asteroids")
	randomize()
	set_process(true)
	screen_size = get_viewport_rect().size

func init(init_size, init_pos, init_vel):
	size = init_size
	if init_vel.length() == 0: #if no initialized vel, then randomize
		vel = Vector2(rand_range(30, 100), 0).rotated(rand_range(0, 2 * PI))
	else:
		vel = init_vel
	rot_speed = rand_range(-1.5, 1.5)
	var texture = load(textures[size][randi() % textures[size].size()])
	get_node("sprite").set_texture(texture)
	extents = texture.get_size() / 2
	var shape = CircleShape2D.new()
	shape.set_radius(min(texture.get_width() / 2, texture.get_height() / 2))
	add_shape(shape)
	set_pos(init_pos)

func _process(delta):
	vel = vel.clamped(300)
	set_rot(get_rot() + rot_speed * delta)
	move(vel * delta)

	if is_colliding():
		vel = get_collision_normal() * (get_collider_velocity().length() * bounce)
		var coll = get_collider()
		coll.vel =  - vel
		puff.set_global_pos(get_collision_pos())
		puff.set_emitting(true)
	# wrap around
	var pos = get_pos()
	if pos.x > screen_size.width + extents.width:
		pos.x = - extents.width
	if pos.x < - extents.width:
		pos.x = screen_size.width + extents.width
	if pos.y > screen_size.height + extents.height:
		pos.y = - extents.height
	if pos.y < - extents.height:
		pos.y = screen_size.height + extents.height
	set_pos(pos)

func explode(hit_dir):
	emit_signal("explode", size, get_pos(), vel, hit_dir)
	queue_free()


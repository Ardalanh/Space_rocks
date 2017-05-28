extends Area2D

var vel = Vector2(0, 0)
var speed = 600
var target_list = []
var target_pos = Vector2(0, 0)
var MAX_RANGE = 600
var target_dist

onready var effect1 = get_node("effect1")
onready var effect2 = get_node("effect2")

func _ready():
	set_process(true)

func _process(delta):
	var pos = get_pos()
	var target_dist = (pos - target_pos).length()
	if target_dist < 10:
		explosion()
		set_process(false)

	set_pos(pos + vel.normalized() * speed * delta)

func start_at(dir, pos, g_mouse):
	set_pos(pos)
	set_rot(dir)
	target_pos = g_mouse
	vel = Vector2(speed, 0).rotated(dir - PI/2)
	effect1.set_emitting(true)
	set_process(true)

func explosion():
	effect1.set_emitting(false)
	effect2.set_emitting(true)
	get_node("timer").start()

func freeze():# timer is signaling to this funcion
	for t in target_list:
		t.take_damage(900)
		t.vel *= 0
	get_node("timer1").start()

func _on_timer1_timeout():
	queue_free()

func _on_ability_1_body_enter( body ):
	if body.is_in_group("enemy"):
		if not target_list.has(body):
			target_list.append(body)

func _on_ability_1_body_exit( body ):
	if body.is_in_group("enemy"):
		if target_list.has(body):
			target_list.erase(body)

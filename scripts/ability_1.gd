extends Area2D

var vel = Vector2(0, 0)
export var speed = 600

onready var effect1 = get_node("effect1")
onready var effect2 = get_node("effect2")
onready var animation = get_node("anim")

func _ready():
	pass
	set_process(true)

func _process(delta):
	vel = vel.normalized() * speed
	set_pos(get_pos() + vel * delta)

func start_at(dir, pos):
	set_pos(pos)
	set_rot(dir)
	vel = Vector2(speed, 0).rotated(dir - PI/2)
	effect1.set_emitting(true)
	animation.play("launch")
	set_process(true)


func _on_anim_finished():
	effect1.set_emitting(false)
	effect2.set_emitting(true)

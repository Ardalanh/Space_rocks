extends Area2D

var vel = Vector2()
var damage = 0
const speed = 1000
onready var sprite = get_node("sprite")
onready var timer = get_node("timer")

func start_at(dir, pos):
	set_rot(dir)
	set_pos(pos)
	vel = Vector2(speed, 0).rotated(dir - PI/2)
	timer.start()
	set_process(true)

func _process(delta):
	set_pos(get_pos() + vel * delta)

func _on_timer_timeout():
	queue_free()


func _on_enemy_bullet2_body_enter( body ):
	if body.is_in_group("player"):
		body.take_damage(damage)
		queue_free()

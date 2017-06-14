extends Area2D

var player
var player_rot
var duration = 5
onready var animation = get_node("animation")
onready var timer = get_node("timer")
onready var particle = get_node("particle")
onready var particle_container = get_node("particle_container")

func __init__(player_obj):
	animation.play("init")
	animation.queue("idle")
	timer.set_wait_time(duration - 1)
	timer.start()
	player = player_obj
	set_process(true)

func _process(delta):
	set_pos(player.get_pos())
#	set_rot(player.get_rot() + PI)

func _on_timer_timeout():
	animation.play("end")

func _on_ability_1_area_enter( area ):
	if area.is_in_group("enemy_bullet"):
		var p = particle.duplicate()
		particle_container.add_child(p)
		p.set_as_toplevel(true)
		p.set_global_pos(area.get_pos())
		p.set_global_rot(area.get_rot()+ PI)
		p.set_emitting(true)
		area.queue_free()

func _on_animation_finished():
	if animation.get_current_animation()=="end":
		queue_free()

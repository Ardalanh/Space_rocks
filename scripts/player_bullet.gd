extends Area2D

var vel = Vector2()
var damage = 0
const speed = 2000
onready var sprite = get_node("bullet")
onready var effect = get_node("animation")

func _ready():
	effect.interpolate_property(sprite, 'visibility/opacity',
	                            1, 0, 0.8, Tween.TRANS_QUAD,
	                            Tween.EASE_IN)
	effect.start()
	set_process(true)

func start_at(dir, pos):
	set_rot(dir)
	set_pos(pos)
	vel = Vector2(speed, 0).rotated(dir - PI/2)

func _process(delta):
	set_pos(get_pos() + vel * delta)

func _on_animation_tween_complete( object, key ):
	queue_free()

func _on_player_bullet_body_enter( body ):
	if body.is_in_group("enemy_target"):
		queue_free()
		body.take_damage(damage)

extends Area2D

var vel = Vector2()
var damage = 0
var target
const speed = 1000
onready var effect = get_node("animation")
onready var sprite = get_node("sprite")

func _ready():
	effect.interpolate_property(sprite, 'visibility/opacity',
	                            1, 1, 1, Tween.TRANS_QUAD,
	                            Tween.EASE_IN)
	effect.start()
	set_process(true)

func start_at(dir, pos, target_obj):
	target = target_obj
	set_rot(dir)
	set_pos(pos)
	vel = Vector2(speed, 0).rotated(dir - PI/2)

func _process(delta):
	var pos = get_pos()
	if target:
		if target.dead:
			queue_free()
			return 0
		var target_pos =target.get_pos()
		look_at(target_pos)
		pos += (target_pos - pos).normalized() * speed * delta
		set_pos(pos)
	else:
		set_pos(get_pos() + vel * delta)

func _on_animation_tween_complete( object, key ):
	queue_free()

func _on_enemy_bullet_body_enter( body ):
	if body.is_in_group("player") or body.is_in_group("planet"):
		body.take_damage(damage)
		queue_free()

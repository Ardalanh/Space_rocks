extends AnimatedSprite

var vel = Vector2(0, 0)

onready var effect = get_node("animation")
onready var explosion_sound = get_node("explosion_sound")

func _ready():
#	pass
	explosion_sound.play("explode1")
	effect.interpolate_property(self, 'visibility/opacity',
	                            1, 0, 1, Tween.TRANS_QUAD,
	                            Tween.EASE_OUT)
	effect.start()
	set_process(true)
func _process(delta):
	set_pos(get_pos() + vel * delta)

func _on_explosion_finished():
	queue_free()

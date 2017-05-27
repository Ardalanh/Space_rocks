extends AnimatedSprite

var vel = Vector2(0, 0)
var ROT_SPEED

onready var effect = get_node("animation")

func _ready():
	randomize()
	effect.interpolate_property(self, 'visibility/opacity',
	                            1, 0.3, 1, Tween.TRANS_QUAD,
	                            Tween.EASE_OUT)
	effect.start()
	ROT_SPEED = rand_range(-PI/2, PI/2)

	set_process(true)

func _process(delta):
	set_pos(get_pos() + vel * delta)
	rotate(ROT_SPEED * delta)

func _on_explosion_finished():
	queue_free()

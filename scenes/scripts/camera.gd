extends Camera2D

onready var spawn_effect = get_node("camera_spawn")
onready var music_1 = get_node("music_1")

func _ready():
	spawn_effect.interpolate_property(self, 'zoom', Vector2(0.1, 0.1), Vector2(1, 1), 26,
	                                  Tween.TRANS_CUBIC, Tween.EASE_IN_OUT)
	spawn_effect.start()
	music_1.play()

extends StaticBody2D

var ROT_SPEED = deg2rad(10)

func _ready():
	set_process(true)

func _process(delta):
	rotate(ROT_SPEED * delta)
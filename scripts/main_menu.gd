extends Node

onready var buttons = get_node("button")
onready var buttons_size = buttons.get_rect().size

func _ready():
	set_process(true)

func _process(delta):
	var screen = get_viewport().get_rect().size
	buttons.set_global_pos(Vector2(screen.x/2 - buttons_size.x/2,
 								screen.y/2 - buttons_size.y/2))

func _on_button_pressed():
	global.new_game()

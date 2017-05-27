extends Control

func _ready():
	get_node("anime").play("loading")
	set_process_input(true)

func _input(event):
	if Input.is_mouse_button_pressed(1):
		_on_anime_finished()

func _on_anime_finished():
	global.goto_scene("res://scenes/main_menu.tscn")

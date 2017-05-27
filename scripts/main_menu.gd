extends Control

onready var threading = Thread.new()

func _ready():
	threading.start(self, "loading")
	get_node("fade_in").play("fading")

func _on_button_pressed():
	global.new_game()

func loading(something):
	preload("res://scenes/game_loop.tscn")
	threading.wait_to_finish()

extends Node

onready var Buttons = get_node("Button")

func _on_Button_pressed():
	global.new_game()

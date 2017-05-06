extends Node

onready var player = get_node("player")
onready var wave = get_node("wave")

func _ready():
	wave.start_spawning(player, get_node("planet").get_global_pos())
	set_process_input(true)

func _input(event):
	if event.is_action_pressed('ui_cancel'):
		get_tree().quit()
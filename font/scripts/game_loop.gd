extends Node

onready var player = get_node("player")
onready var wave = get_node("wave")
onready var HUD = get_node("hud")

func _ready():
	HUD.next_wave()
	set_process_input(true)

func _input(event):
	if event.is_action_pressed('ui_cancel'):
		get_tree().quit()

func _on_restart_timer_timeout():
	get_tree().set_pause(false)
	global.new_game()

func _on_hud_next_wave():

	global.wave_num += 1
	HUD.show_message("Wave %s" % global.wave_num)
	wave.start_spawning(player, get_node("planet").get_global_pos())

func _on_player_player_dead():
	HUD.show_message("Game Over")
	get_node("restart_timer").start()
	get_tree().set_pause(true)

func _on_wave_wave_done():
	if global.wave_num == 3:
		HUD.show_message("You Won, I'm impressed!")
		get_node("restart_timer").start()
		return null
	HUD.next_wave()

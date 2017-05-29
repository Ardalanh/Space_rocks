extends Node

onready var HUD = get_node("hud")

enum _States{start,
			wait,
			spawn,
			def,
			game_over,
			victory,
			lost}

signal player_dead
signal wave_timeout

var state = _States.start
var planet_live = true

func _ready():
	set_process(true)
	set_process_input(true)

func _process(delta):
	if state == _States.start:
		start_state() #Start screen of explaining the game or anything
	elif state == _States.wait:
		wait_state()
	elif state == _States.spawn:
		spawn_state()
	elif state == _States.def:
		def_state()
	elif state == _States.game_over:
		game_over_state()
	elif state == _States.victory:
		victory_state()
	elif state == _States.lost:
		lost_state()

func start_state():
	state =  _States.spawn

func wait_state():
	pass

func spawn_state():
	if global.wave_num < 3:
		HUD.next_wave()
		state = _States.wait
	else:
		state = _States.game_over

func def_state():
	pass

func game_over_state():
	if planet_live:
		state = _States.victory
	else:
		state = _States.lost

func victory_state():
	print("we've done it")

func lost_state():
	HUD.show_message("Game Over")
	get_node("restart_timer").start()
	get_tree().set_pause(true)

func _input(event):
	if event.is_action_pressed('ui_cancel'):
		get_tree().quit()

func _on_restart_timer_timeout():
	get_tree().set_pause(false)
	global.new_game()

func _on_wave_wave_done():
	state = _States.spawn

func _on_planet_Dead():
	planet_live = false
	state = _States.game_over

func _on_hud_wave_timeout():
	emit_signal("wave_timeout")
	state = _States.def

func _on_player_player_dead(time):
	emit_signal("player_dead")
	get_node("camera").make_current()

func _on_player_player_alive():
	get_node("camera").clear_current()

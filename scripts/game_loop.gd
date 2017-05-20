extends Node

onready var HUD = get_node("hud")

enum _States{start,
			wait,
			spawn,
			def,
			game_over,
			victory,
			lost}

var state = _States.start
var planet_live = true

func _ready():
	set_process(true)
	set_process_input(true)

func _process(delta):
	if state == _States.start:
		start() #Start screen of explaining the game or anything
	elif state == _States.wait:
		wait()
	elif state == _States.spawn:
		spawn()
	elif state == _States.def:
		def()
	elif state == _States.game_over:
		game_over()
	elif state == _States.victory:
		victory()
	elif state == _States.lost:
		lost()

func start():
	state =  _States.spawn

func wait():
	pass

func spawn():
	if global.wave_num < 3:
		HUD.next_wave()
		state = _States.wait
	else:
		state = _States.game_over

func def():
	pass

func game_over():
	if planet_live:
		state = _States.victory
	else:
		state = _States.lost

func victory():
	print("we've done it")

func lost():
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

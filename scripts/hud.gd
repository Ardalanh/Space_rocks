extends CanvasLayer

signal wave_timeout

var screen

onready var wave_label = get_node("next_wave")
onready var enemy_remain = get_node("enemy_remain")
onready var wave_timer = get_node("next_wave/next_wave_timer")
onready var respawn
onready var respawn_timer
onready var planet_hp = get_node("panel/planet_hp")

func _ready():
	set_process_input(true)
	set_process(true)
	respawn = get_node("respawn")
	respawn_timer = get_node("respawn/timer")

func _input(event):
	planet_hp.set_max(global.planet_max_hp)
	if event.is_action_pressed("pause_toggle"):
		global.paused = not global.paused
		get_tree().set_pause(global.paused)
		get_node("pause_popup").set_hidden(not global.paused)
		get_node("message").set_hidden(global.paused)


func next_wave():
	wave_label.show()
	wave_timer.start()

func _process(delta):
	planet_hp.set_value(global.planetHP)
	get_node("panel/planet_hp/hp").set_text(str(global.planetHP))
	wave_label.set_text("Next wave in: " + str(int(wave_timer.get_time_left())))
	respawn.set_text("respawn in: " + str(int(respawn_timer.get_time_left() + 1)))

func show_message(text):
	get_node("message").set_text(text)
	get_node("message").show()
	get_node("message_timer").start()

func show_respawn_timer(time):
	respawn_timer.set_wait_time(time)
	respawn.show()
	respawn_timer.start()

func _on_message_timer_timeout():
	get_node("message").hide()
	get_node("message").set_text('')

func _on_next_wave_timer_timeout():
	global.wave_num += 1
	show_message("Wave %s" % global.wave_num)
	wave_label.hide()
	emit_signal("wave_timeout")

func _on_wave_number_of_enemies(num):
	enemy_remain.set_text(str(num))

func _on_player_player_dead(time):
	show_respawn_timer(time)

func _on_timer_timeout():
	respawn.hide()
	respawn.set_text('')

func _on_button_1_button_down():
	Input.action_press("player_ability_1")
	print("WE PRESSED")

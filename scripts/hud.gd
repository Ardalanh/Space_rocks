extends CanvasLayer

signal wave_timeout

var screen
var respawn

onready var wave_label = get_node("next_wave")
onready var enemy_remain = get_node("enemy_remain")
onready var wave_timer = get_node("next_wave/next_wave_timer")
onready var respawn_label = get_node("respawn_time")
onready var planet_hp = get_node("control/planet_hp")
onready var planet_hp_size = planet_hp.get_rect().size

func _ready():
	set_process_input(true)
	set_process(true)
	respawn = get_node("respawn_time/Timer")

func _input(event):
	if event.is_action_pressed("pause_toggle"):
		global.paused = not global.paused
		get_tree().set_pause(global.paused)
		get_node("pause_popup").set_hidden(not global.paused)
		get_node("message").set_hidden(global.paused)

func next_wave():
	wave_label.show()
	wave_timer.start()

func _process(delta):
	screen = get_viewport().get_rect().size
	if planet_hp.get_max() != global.planet_max_hp:
		planet_hp.set_max(global.planet_max_hp)
	planet_hp.set_value(global.planetHP)
	planet_hp.set_pos(Vector2(screen.x/2 - planet_hp_size.x/2,
							screen.y - planet_hp_size.y-10))
	get_node("control/planet_hp/hp").set_text(str(global.planetHP))
	wave_label.set_text("Next wave in: " + str(int(wave_timer.get_time_left())))
	respawn_label.set_text("Respawn in: " + str(int(respawn.get_time_left())))

func show_message(text):
	get_node("message").set_text(text)
	get_node("message").show()
	get_node("message_timer").start()

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


func _on_player_player_dead(respawn_time):
	respawn_label.show()
	respawn.set_wait_time(respawn_time)
	respawn.start()
	



func _on_Timer_timeout():
		get_node("respawn_time").hide()


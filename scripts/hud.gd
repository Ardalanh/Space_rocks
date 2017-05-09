extends CanvasLayer

signal next_wave

onready var wave_label = get_node("next_wave")
onready var enemy_remain = get_node("enemy_remain")
onready var wave_timer = get_node("next_wave/next_wave_timer")

func _ready():
	set_process_input(true)

func _input(event):
	if event.is_action_pressed("pause_toggle"):
		global.paused = not global.paused
		get_tree().set_pause(global.paused)
		get_node("pause_popup").set_hidden(not global.paused)
		get_node("message").set_hidden(global.paused)

func next_wave():
	wave_label.show()
	wave_timer.start()
	set_process(true)

func _process(delta):
	wave_label.set_text("Next wave in: " + str(int(wave_timer.get_time_left())))

func show_message(text):
	get_node("message").set_text(text)
	get_node("message").show()
	get_node("message_timer").start()


func _on_message_timer_timeout():
	get_node("message").hide()
	get_node("message").set_text('')

func _on_next_wave_timer_timeout():
	emit_signal("next_wave")
	wave_label.hide()
	set_process(false)

func _on_wave_number_of_enemies(num):
	enemy_remain.set_text(str(num))

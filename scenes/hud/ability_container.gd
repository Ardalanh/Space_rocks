extends HBoxContainer

var buttons = []

func _ready():
	for child in get_children():
		buttons.append(child)
	set_process(true)

func _process(delta):
	for button in buttons:
		button.get_node("cd_mask").set_value(button.get_node("cd_timer").get_time_left())
extends HBoxContainer

signal player_lvl_up

var buttons = []

func _ready():
	var player = get_tree().get_nodes_in_group("player_obj")[0]
	var i = 1
	for child in get_children():
		buttons.append(child)
		child.connect("pressed", player, "cast_ability", [i])
		child.get_node("lvl_up_mask").connect("input_event", self, "ability_lvl_up", [i])
		i += 1
	set_process(true)

func _process(delta):
	for button in buttons:
		var time_left = button.get_node("cd_timer").get_time_left()
		var cd_mask = button.get_node("cd_mask")
		var cd_label = button.get_node("cd_label")
		if time_left:
			cd_mask.show()
			cd_mask.set_value(time_left)
			cd_label.show()
			cd_label.set_text(str(int(time_left) + 1))
		else:
			cd_mask.hide()
			cd_label.hide()

func _player_lvl_up_screen():
	for button in buttons:
		button.set_ignore_mouse(true)
		button.set_stop_mouse(false)
		button.get_node("lvl_up_mask").show()


func ability_lvl_up(event, ability_num):
	if event.is_action_released("mouse_left_click"):
		emit_signal("player_lvl_up", ability_num)
		for button in buttons:
			button.set_ignore_mouse(false)
			button.set_stop_mouse(true)
			button.get_node("lvl_up_mask").hide()

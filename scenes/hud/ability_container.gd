extends HBoxContainer

var buttons = []

func _ready():
	var player = get_tree().get_nodes_in_group("player_obj")[0]
	var i = 1
	for child in get_children():
		buttons.append(child)
		child.connect("pressed", player, "cast_ability", [i])
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
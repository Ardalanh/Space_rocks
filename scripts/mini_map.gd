extends Control

var player = Vector2()

func _ready():
	player = get_tree().get_nodes_in_group("player_obj")[0]
	set_as_toplevel(true)
	set_process(true)

func _process(delta):
	set_pos(Vector2(get_viewport_transform().inverse().get_origin().x, get_viewport_transform().inverse().get_origin().y) + Vector2(0, get_viewport_rect().size.y - 150))

	var camera = get_node("vp/cam")
	camera.set_pos(player.get_pos() * 0.1)


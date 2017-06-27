extends Control

onready var vp = get_node("vp")

var player
onready var enemy_sprite = get_node("enemy")
onready var planet_sprite = get_node("vp/planet")
onready var player_sprite = get_node("vp/player")
onready var portal_sprite = get_node("portal")

var sprites = {}
var enemy_sprites = {}

func _ready():
	var portals = get_tree().get_nodes_in_group("portals")[0].get_children()
	for p in portals:
		var s = portal_sprite.duplicate()
		s.show()
		vp.add_child(s)
		s.set_pos(p.get_pos() * 0.015)

	var planet = get_tree().get_nodes_in_group("planet")[0]
	planet_sprite.show()
	planet_sprite.set_pos(planet.get_pos() * 0.015)

	player = get_tree().get_nodes_in_group("player_obj")[0]
	player_sprite.show()
	player_sprite.set_pos(player.get_pos() * 0.015)
	sprites[player] = player_sprite

	set_as_toplevel(true)
	set_process(true)

func _process(delta):
	set_pos(Vector2(get_viewport_transform().inverse().get_origin().x, get_viewport_transform().inverse().get_origin().y) + Vector2(0, get_viewport_rect().size.y - 150))

	for obj in sprites.keys():
		if weakref(obj).get_ref():
			sprites[obj].set_pos(obj.get_pos() * 0.015)
			sprites[obj].set_rot(obj.get_rot() + PI)
		else:
			sprites[obj].queue_free()
			sprites.erase(obj)

#	var camera = get_node("vp/cam")
#	camera.set_pos(player.get_pos() * 0.015)


func _on_wave_new_enemy(e):
	var s = enemy_sprite.duplicate()
	s.show()
	vp.add_child(s)
	s.set_pos(e.get_pos() * 0.015)
	sprites[e] = s

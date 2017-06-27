extends Control

onready var vp = get_node("vp")

var player
var enemy_sprite = load("res://art/mini_map/enemy_001.tex")
var planet_sprite = load("res://art/mini_map/planet_001.tex")
var player_sprite = load("res://art/mini_map/player_001.tex")
var portal_sprite = load("res://art/mini_map/Voretx_001.tex")

var sprites = {}
var enemy_sprites = {}

func _ready():
	var portals = get_tree().get_nodes_in_group("portals")[0].get_children()
	for p in portals:
		var s = Sprite.new()
		s.set_texture(portal_sprite)
		vp.add_child(s)
		s.set_pos(p.get_pos() * 0.015)
		sprites[p.get_instance_ID()] = s

	player = get_tree().get_nodes_in_group("player_obj")[0]
	var s = Sprite.new()
	s.set_texture(player_sprite)
	vp.add_child(s)
	s.set_pos(player.get_pos() * 0.015)
	sprites[player.get_instance_ID()] = s

	var planet = get_tree().get_nodes_in_group("planet")[0]
	s = Sprite.new()
	s.set_texture(planet_sprite)
	vp.add_child(s)
	s.set_pos(planet.get_pos() * 0.015)
	sprites[planet.get_instance_ID()] = s

	set_as_toplevel(true)
	set_process(true)

func _process(delta):
	set_pos(Vector2(get_viewport_transform().inverse().get_origin().x, get_viewport_transform().inverse().get_origin().y) + Vector2(0, get_viewport_rect().size.y - 150))

#	for e in get_tree().get_nodes_in_group("enemy"):
#		var ID = e.get_instance_ID()
#		if ID in sprites.values():
#			enemy_sprites[ID].set_pos(e.get_pos() * 0.015)
#			enemy_sprites[ID].set_rot(e.get_rot() + PI)
#		else:
#			var s = Sprite.new()
#			s.set_texture(enemy_sprite)
#			vp.add_child(s)
#			s.set_pos(e.get_pos() * 0.015)
#			s.set_scale(Vector2(0.2, 0.2))
#			enemy_sprites[ID] = s

	sprites[player.get_instance_ID()].set_pos(player.get_pos() * 0.015)
	sprites[player.get_instance_ID()].set_rot(player.get_rot() + PI)
#	var camera = get_node("vp/cam")
#	camera.set_pos(player.get_pos() * 0.015)

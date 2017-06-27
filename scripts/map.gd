extends Node2D

var portal_frames = preload("res://art/PNG/portal/portal.xml")
var portal = preload("res://scenes/portal.tscn")

var portal_positions = [Vector2(0, -4000), Vector2(3464, 2000), Vector2(-3464, 2000)]

func _ready():
	var portal_container = get_node("portals")
	for i in range(3):
		var p = portal.instance()
		portal_container.add_child(p)
		p.set_pos(portal_positions[i])


extends Node2D

signal no_more_portal

var portal_frames = preload("res://art/PNG/portal/portal.xml")
var portal = preload("res://scenes/portal.tscn")
var num_of_portals = 3

var portal_positions = [Vector2(0, -4000), Vector2(3464, 2000), Vector2(-3464, 2000)]

func _ready():
	var portal_container = get_node("portals")
	for i in range(num_of_portals):
		var p = portal.instance()
		portal_container.add_child(p)
		p.set_pos(portal_positions[i])
		p.connect("portal_destroyed", self, "_on_portal_destruction")

func _on_portal_destruction():
	num_of_portals += -1
	if num_of_portals <= 0:
		emit_signal("no_more_portal")
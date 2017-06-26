extends Node2D

signal wave_done
signal number_of_enemies

var explosion = preload("res://scenes/explosion.tscn")
var enemy_1 = preload("res://scenes/creep_scenes/enemy1.tscn")

onready var enemy_container = get_node("enemy_container")
onready var spawn_rate = get_node("spawn_rate")

var spawn_pos = []

var number_of_units = 18
var player
var planet_pos
var planet_radius
var r = 1500
var theta = 0
var enemy
var i = 0

func _ready():
	var portal_nodes = get_tree().get_nodes_in_group("portals")[0]
	for portal in portal_nodes.get_children():
		spawn_pos.append(portal.get_global_pos())


func _process(delta):
	spawn()
	emit_signal("number_of_enemies", enemy_container.get_child_count())
	if no_enemies():
		i = 0
		emit_signal("wave_done")
		set_process(false)


func _on_enemy_explode(expl_pos, expl_vel):
	var expl = explosion.instance()
	add_child(expl)
	expl.set_pos(expl_pos)
	expl.vel = expl_vel

func no_enemies():
	if enemy_container.get_child_count() == 0:
		return true
	else:
		return false

func spawn():
	if spawn_rate.get_time_left() == 0 and number_of_units > 0:
		var e = enemy_1.instance()
		e.start_at(spawn_pos[i%3], planet_pos, planet_radius)
		e.connect("explode", self, "_on_enemy_explode")
		spawn_rate.start()
		enemy_container.add_child(e)
		number_of_units -= 1
		i += 1


func _on_wave_timeout():
	set_process(true)
	i = 0

func _on_planet_planet_pos_signal(planet_p, planet_r):
	planet_pos = planet_p
	planet_radius = planet_r

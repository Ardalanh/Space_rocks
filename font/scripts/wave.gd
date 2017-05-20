extends Node

signal wave_done
signal number_of_enemies

#export (PackedScene) var enemy
var explosion = preload("res://scenes/explosion.tscn")
var enemy_factory = preload("res://scenes/enemy_wave.tscn").instance()

onready var enemy_container = get_node("enemy_container")
onready var spawn_rate = get_node("spawn_rate")
onready var spawn_node = get_node("spawn_pos")
var number_of_units = 24
var player
var planet_pos
var r = 1500
var theta = 0
var enemy

func _ready():
	spawn_node.set_pos(Vector2(r, 0))

func start_spawning(player_obj, planet):
	number_of_units = 9
	r = 1500
	theta = 0
	set_process(true)
	player =  player_obj
	planet_pos = planet

func _process(delta):
	if spawn_rate.get_time_left() == 0 and number_of_units > 0:
		var e = enemy_factory.Generate(global.wave_num - 1)
		enemy_container.add_child(e)
		e.start_at(spawn_node.get_global_pos(), player, planet_pos)
		e.connect("explode", self, "_on_enemy_explode")
		spawn_rate.start()
		number_of_units -= 1
		change_spawn_pos()
	emit_signal("number_of_enemies", enemy_container.get_child_count())
	if no_enemies():
		emit_signal("wave_done")
		set_process(false)

func change_spawn_pos():
	var s_pos = spawn_node.get_global_pos()
	theta += deg2rad(-120)
	s_pos = Vector2(r * cos(theta) , r * sin(theta))
	spawn_node.set_global_pos(s_pos)

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
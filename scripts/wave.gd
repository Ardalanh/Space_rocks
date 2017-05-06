extends Node

export (PackedScene) var enemy
onready var enemy_container = get_node("enemy_container")
onready var spawn_rate = get_node("spawn_rate")
var number_of_units = 10
var player
var planet_pos

func _ready():
	pass

func start_spawning(player_obj, planet):
	set_process(true)
	player =  player_obj
	planet_pos = planet

func _process(delta):
	if spawn_rate.get_time_left() == 0 and number_of_units > 0:
		var e = enemy.instance()
		enemy_container.add_child(e)
		e.start_at(get_node("spawn_pos").get_global_pos(), player, planet_pos)
		spawn_rate.start()
		number_of_units -= 1

	if number_of_units <= 0:
		number_of_units = 10
		set_process(false)

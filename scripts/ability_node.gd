extends Node

signal ability_casted

onready var timer_container = get_node("timer_container")

var abilities = {}

var timers = {}
#var cooldowns = {}
var levels = {}
const MAX_LVL = 4

func _ready():
	for i in range(1,4):
		var name = "ability_%d"%i
		abilities[name] = load("res://scenes/abilities/ability_%d.tscn"%i)
		timers[name] = Timer.new()
		timers[name].set_one_shot(true)
		timer_container.add_child(timers[name])
		levels[name] = 1

func cast(index):
	var name = "ability_%d"%index
	print(timers[name].get_time_left())
	if timers[name].get_time_left() == 0:
		var a = abilities[name].instance()
		add_child(a)
		a.__init__(get_parent(), levels[name])
		var cd = a.get_cooldown()
		timers[name].set_wait_time(cd)
		timers[name].start()
		emit_signal("ability_casted", name, cd)

func level_up_ability(index):
	var name = "ability_%d"%index
	if levels[name] < MAX_LVL:
		levels[name] += 1

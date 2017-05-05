extends Node

onready var player = get_node("player")
onready var wave = get_node("wave")

func _ready():
	wave.start_spawning(player, get_node("planet").get_global_pos())
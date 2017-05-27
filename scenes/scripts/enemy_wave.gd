extends Node

func _ready():
	pass

func Generate(index):
	return load("res://scenes/creep_scenes/enemy%d.tscn"%index).instance()
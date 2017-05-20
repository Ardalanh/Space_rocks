extends Node

func _ready():
	pass

func Generate(index):
	return get_child(index).duplicate()
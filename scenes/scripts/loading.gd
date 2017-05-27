extends Control

export (PackedScene) var next_scene


func _ready():
	var anime = get_node("anime")
	anime.play("anime")
	pass


func _on_anime_finished():
	global.goto_scene("res://scenes/main_menu.tscn")
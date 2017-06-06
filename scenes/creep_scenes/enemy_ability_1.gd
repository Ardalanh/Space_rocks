extends Node2D

var enemy
export (PackedScene) var bullet

func __init__(enemy_obj):
	enemy = enemy_obj
	shoot()
	queue_free()

func shoot():
	var rot = enemy.get_rot()
	for i in range(-45, 45, 5):
		var b = bullet.instance()
		enemy.bullet_container.add_child(b)
		b.damage = enemy.damage * 2.25
		b.start_at(deg2rad(i) + rot, enemy.get_node("gun").get_global_pos())